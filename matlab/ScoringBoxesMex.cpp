#include "mex.h"
#include "math.h"
#include <vector>
#include <algorithm>
#include <iostream>
#include <string>

using namespace std;
int clamp( int v, int a, int b ) { return v<a?a:v>b?b:v; }

// trivial array class encapsulating pointer arrays
template <class T> class Array
{
public:
  Array() { _h=_w=0; _x=0; _free=0; }
  virtual ~Array() { clear(); }
  void clear() { if(_free) delete [] _x; _h=_w=0; _x=0; _free=0; }
  void init(int h, int w) { clear(); _h=h; _w=w; _x=new T[h*w](); _free=1; }
  T& val(size_t c, size_t r) { return _x[c*_h+r]; }
  int _h, _w; T *_x; bool _free;
};

typedef Array<float> arrayf;

typedef struct {int x,y;} coordinate;
typedef vector<coordinate> Segment;
typedef vector<Segment> SegList;

typedef struct { int c, r, w, h; float s; } Box;
typedef vector<Box> Boxes;
typedef vector<int> vectori;
typedef struct {float con, pro;} RI;
typedef struct {vectori SegsId; vectori labels;} Segs_with_Labels;

bool inbox(Box &box, Segment &segment, float thr,int ind);
float ranksvmScore(Segment &segment_a, Segment &segment_b, RI &ri, arrayf &O);
float proximity(coordinate &a, coordinate &b);
float continuity(coordinate &a, coordinate &b, arrayf &O);
float closure(Segment &segment, float box_side);
bool boxesCompare( const Box &a, const Box &b ) { return a.s<b.s; }
float boxesOverlap( Box &a, Box &b );
void boxesNms( Boxes &boxes, float thr, int maxBoxes );
Boxes removebox(Boxes &boxes, float score);

class ScoringAllboxes
{
public:
    float _alpha, _beta, _minBoxArea, _maxAspectRatio; int _maxBoxes;
    void Scoring(SegList &seglist, Boxes &boxes, vectori &labels, RI &ri, arrayf &O, arrayf &E);
private:

    int h, w; //image dimension
    float _scStep, _arStep, _rcStepRatio;
    void refineBox( Box &box,SegList &seglist,vectori &labels, RI &ri, arrayf &O );
    Segs_with_Labels findSegs(SegList &seglist, vectori &labels, Box &box);
    float Scorebox(Box &box, SegList &seglist,vectori &labels, RI &ri, arrayf &O);
};

void ScoringAllboxes::Scoring(SegList &seglist, Boxes &boxes, vectori &labels, RI &ri, arrayf &O,arrayf &E)
{
    w = E._w;
    h = E._h;
    
    _scStep=sqrt(1/_alpha);
    _arStep=(1+_alpha)/(2*_alpha);
    _rcStepRatio=(1-_alpha)/(1+_alpha);
    // get list of all boxes roughly distributed in grid
    boxes.resize(0); int arRad, scNum; float minSize=sqrt(_minBoxArea);
    arRad = int(log(_maxAspectRatio)/log(_arStep*_arStep));
    scNum = int(ceil(log(max(w,h)/minSize)/log(_scStep)));
    int boxcnt = 0;
    
  for( int s=0; s<scNum; s++ ) {
    int a, r, c, bh, bw, kr, kc, bId=-1; float ar, sc;
    for( a=0; a<2*arRad+1; a++ ) {
      ar=pow(_arStep,float(a-arRad)); sc=minSize*pow(_scStep,float(s));
      bh=int(sc/ar); kr=max(2,int(bh*_rcStepRatio));
      bw=int(sc*ar); kc=max(2,int(bw*_rcStepRatio));
      for( c=0; c<w-bw+kc; c+=kc ) for( r=0; r<h-bh+kr; r+=kr ) {
        Box b; b.r=r; b.c=c; b.h=bh; b.w=bw; boxes.push_back(b);
        boxcnt++;
      }
    }
  }
    
    int k = 0;
    int r0, c0, r1, c1;
    
    for(int i=0;i<boxes.size();i++){
        Box box = boxes[i];
        // make sure the boundary of box in range
        r1=clamp(box.r+box.h,0,h-1); r0=box.r=clamp(box.r,0,h-1);
        c1=clamp(box.c+box.w,0,w-1); c0=box.c=clamp(box.c,0,w-1);
        box.h=r1-box.r; box.w=c1-box.c;
        boxes[i] = box;
        
        Box center_box;
        center_box.c = int(box.c+box.w/4);
        center_box.r = int(box.r+box.h/4);
        center_box.w = int(box.w/2);
        center_box.h = int(box.h/2);

        float score = Scorebox(box, seglist, labels, ri,O);
        float score_cen = Scorebox(center_box, seglist, labels, ri, O);
        
        boxes[i].s = score - score_cen;

        if(!score) continue;
        k++;
        refineBox(boxes[i],seglist, labels, ri,O);
    }

    for(int i=0;i<boxes.size();i++){
        Box box = boxes[i];
        // make sure the boundary of box in range
        r1=clamp(box.r+box.h,0,h-1); r0=box.r=clamp(box.r,0,h-1);
        c1=clamp(box.c+box.w,0,w-1); c0=box.c=clamp(box.c,0,w-1);
        box.h=r1-box.r; box.w=c1-box.c;
        boxes[i] = box;
    }
    sort(boxes.rbegin(),boxes.rend(),boxesCompare);
    boxes.resize(k); boxesNms(boxes,_beta,_maxBoxes);
}

void ScoringAllboxes::refineBox( Box &box,SegList &seglist,vectori &labels, RI &ri, arrayf &O )
{
  _rcStepRatio=(1-_alpha)/(1+_alpha);
  int rStep = int(box.h*_rcStepRatio);
  int cStep = int(box.w*_rcStepRatio);
  while( 1 ) {
    // prepare for iteration
    rStep/=2; cStep/=2; if( rStep<=2 && cStep<=2 ) break;
    rStep=max(1,rStep); cStep=max(1,cStep); Box B;
    // search over r start
    B=box; B.r=box.r-rStep; B.h=B.h+rStep; B.s = Scorebox(B,seglist,labels,ri,O);
    if(B.s<=box.s) { B=box; B.r=box.r+rStep; B.h=B.h-rStep; B.s = Scorebox(B,seglist,labels,ri,O); }
    if(B.s>box.s) box=B;
    // search over r end
    B=box; B.h=B.h+rStep; B.s = Scorebox(B,seglist,labels,ri,O);
    if(B.s<=box.s) { B=box; B.h=B.h-rStep; B.s = Scorebox(B,seglist,labels,ri,O); }
    if(B.s>box.s) box=B;
    // search over c start
    B=box; B.c=box.c-cStep; B.w=B.w+cStep; B.s = Scorebox(B,seglist,labels,ri,O);
    if(B.s<=box.s) { B=box; B.c=box.c+cStep; B.w=B.w-cStep; B.s = Scorebox(B,seglist,labels,ri,O); }
    if(B.s>box.s) box=B;
    // search over c end
    B=box; B.w=B.w+cStep; B.s = Scorebox(B,seglist,labels,ri,O);
    if(B.s<=box.s) { B=box; B.w=B.w-cStep; B.s = Scorebox(B,seglist,labels,ri,O); }
    if(B.s>box.s) box=B;
  }
}

Segs_with_Labels ScoringAllboxes::findSegs(SegList &seglist,vectori &labels, Box &box)
{
    Segs_with_Labels segswithlabels;
    float thr = 0.88;
    for(int i=0;i<seglist.size();i++){
        Segment seg = seglist[i];
        int label = labels[i];

        if (inbox(box,seg,thr,i)){
            segswithlabels.SegsId.push_back(i);
            segswithlabels.labels.push_back(label);
        }
    }
    return segswithlabels;
}

bool inbox(Box &box, Segment &segment, float thr,int ind)
{
    vector<bool> inboxpixel;
    bool seg_inbox;
    for(int i=0;i<segment.size();i++){
        int coordx = segment[i].x;
        int coordy = segment[i].y;
       
        if ((coordx >= box.c) && (coordx <= (box.c+box.w)) && (coordy >= box.r) && (coordy<=(box.r+box.h))){
            inboxpixel.push_back(1);
        }
    }
    
    if (float(inboxpixel.size())/segment.size() > thr)
            seg_inbox = true;
    else
        seg_inbox = false;
    
    return seg_inbox;
}

float ScoringAllboxes::Scorebox(Box &box, SegList &seglist, vectori &labels, RI &ri, arrayf &O)
{
        
        Segs_with_Labels segwithlabel = findSegs(seglist,labels,box);
        vectori SegsId = segwithlabel.SegsId;
        vectori inboxlabels = segwithlabel.labels;
        
    if(SegsId.size()>0){
        int cnt_aff = 1 ;
        float aff = 1;
        double boxScore = 0;
        float totalLen = 0;
        float percent_in_g = 0;
        
        vectori SegsId_smooth;
        vectori inboxlabels_smooth;
        vector<int> uniqueLabel;
        vector<int> x;
        vector<int> y;
        
        uniqueLabel.resize(0);
        for(int i=0;i<SegsId.size();i++){
            Segment seg_a = seglist[SegsId[i]];
            int label = inboxlabels[i];

            if(find(uniqueLabel.begin(),uniqueLabel.end(),label) == uniqueLabel.end())
                uniqueLabel.push_back(label);
            
            // insert x y position into vector
            for(int k=0; k<seg_a.size();k++){
                int xpos = seg_a[k].x;
                int ypos = seg_a[k].y;
                if ((xpos >= box.c) && (xpos <= (box.c+box.w)) && (ypos >= box.r) && (ypos<=(box.r+box.h))){
                    x.push_back(xpos);
                    y.push_back(ypos);
                    totalLen++;
                }
            }

        }
        
        // compute convexhull;
        int convexhull = 0;
        int convexhull_v = 0;
        int convexhull_h = 0;
        
        vectori convexhull_verti;
        for(int i=0;i<box.w;i++){
            int col = box.c + i;

            for(int j=0;j<x.size();j++){

                if(abs(x[j] - col)<2){
                    convexhull_verti.push_back(y[j]);
                }
            }

            if(convexhull_verti.size()){
                convexhull_v += (*max_element(convexhull_verti.begin(),convexhull_verti.end()) -\
                    *min_element(convexhull_verti.begin(),convexhull_verti.end()));
            }
            convexhull_verti.clear();
        }
        
        vectori convexhull_horiz;
        for(int i=0;i<box.h;i++){
            int row = box.r + i;
            
            
            for(int j=0;j<x.size();j++){
                if(abs(y[j] - row)<2)
                    convexhull_horiz.push_back(x[j]);
            }
            if(convexhull_horiz.size())
                convexhull_h += (*max_element(convexhull_horiz.begin(),convexhull_horiz.end()) -\
                    *min_element(convexhull_horiz.begin(),convexhull_horiz.end()));
            
            convexhull_horiz.clear();
        }
        
        convexhull = (convexhull_v+convexhull_h)/2;
        
        int k = 1, r=1, g=1.5,c=2;
//         define box area
        float boxArea = box.w*box.h;

        float fullfill = pow(convexhull,k)/boxArea;

        float compactness = 0;

        int num_groups = uniqueLabel.size();

        float groupinfo = pow(float(num_groups),g)/pow((box.w+box.h),1);
        
        // Length
        float Len = pow(totalLen,r)/pow((box.w+box.h),1.5);
        
        // box score
        boxScore = Len*fullfill/(groupinfo);

        return boxScore;
    }
    else
        return 0;
}


float boxesOverlap( Box &a, Box &b ) {
  float areai, areaj, areaij;
  int r0, r1, c0, c1, r1i, c1i, r1j, c1j;
  r1i=a.r+a.h; c1i=a.c+a.w; if( a.r>=r1i || a.c>=c1i ) return 0;
  r1j=b.r+b.h; c1j=b.c+b.w; if( a.r>=r1j || a.c>=c1j ) return 0;
  areai = (float) a.w*a.h; r0=max(a.r,b.r); r1=min(r1i,r1j);
  areaj = (float) b.w*b.h; c0=max(a.c,b.c); c1=min(c1i,c1j);
  areaij = (float) max(0,r1-r0)*max(0,c1-c0);
  return areaij / (areai + areaj - areaij);
}

void boxesNms( Boxes &boxes, float thr, int maxBoxes )
{
  sort(boxes.rbegin(),boxes.rend(),boxesCompare);
  if( thr>.99 ) return; const int nBin=10000;
  const float step=1/thr, lstep=log(step);
  vector<Boxes> kept; kept.resize(nBin+1);
  int i=0, j, k, n=(int) boxes.size(), m=0, b;
  while( i<n && m<maxBoxes ) {
    b = boxes[i].w*boxes[i].h; bool keep=1;
    b = clamp(int(ceil(log(float(b))/lstep)),1,nBin-1);
    for( j=b-1; j<=b+1; j++ )
      for( k=0; k<kept[j].size(); k++ ) if( keep )
        keep = boxesOverlap( boxes[i], kept[j][k] ) <= thr;
    if(keep) { kept[b].push_back(boxes[i]); m++; } i++;
  }
  boxes.resize(m); i=0;
  for( j=0; j<nBin; j++ )
    for( k=0; k<kept[j].size(); k++ )
      boxes[i++]=kept[j][k];
  sort(boxes.rbegin(),boxes.rend(),boxesCompare);
}



void mexFunction(int nl, mxArray *pl[], int nr, const mxArray *pr[])
{
    if(nr != 10){
        mexErrMsgTxt("input number error.");
    }
    
    mwSize m, n, NSegs;
    mwIndex SegId;
    coordinate cor;
    SegList seglist;
    NSegs = mxGetNumberOfElements(pr[0]);
    for(int i=0;i<NSegs;i++){
        Segment seg;
        mxArray *seg_pr = mxGetCell(pr[0],i);
        double* data = mxGetPr(seg_pr);
        m = mxGetM(seg_pr);
        n = mxGetN(seg_pr);
        for(int j=0; j<m; j++){
            cor.y = (int) data[j];
            cor.x = (int) data[m+j];
            seg.push_back(cor);
        }
        seglist.push_back(seg);
    }

     ScoringAllboxes S;
     Boxes boxes; Box b;

     
     int* labels_pr = (int*) mxGetData(pr[1]);
     int M_label = mxGetM(pr[1]);
     vectori labels;
     for(int i=0;i<M_label;i++){
        labels.push_back(labels_pr[i]);
     }

     
     
     double* ri_pr = mxGetPr(pr[2]);
     int m_ri = mxGetM(pr[2]);
     int n_ri = mxGetN(pr[2]);
     RI ri;
     ri.pro = *ri_pr;
     ri.con = *(ri_pr+1);

     arrayf O;
     O._x = (float*) mxGetData(pr[3]);
     int h = (int) mxGetM(pr[3]); O._h=h;
     int w = (int) mxGetN(pr[3]); O._w=w;

     arrayf E;
     E._x = (float*) mxGetData(pr[4]);
     E._h = h;
     E._w = w;
     
     S._alpha = float(mxGetScalar(pr[5]));
     S._beta = float(mxGetScalar(pr[6]));
     S._minBoxArea = float(mxGetScalar(pr[7]));
     S._maxAspectRatio = float(mxGetScalar(pr[8]));
     S._maxBoxes = (int) mxGetScalar(pr[9]);
     S.Scoring(seglist, boxes, labels, ri,O,E);
    
     int n_bx = (int) boxes.size();
     
    pl[0] = mxCreateNumericMatrix(n_bx,5,mxSINGLE_CLASS,mxREAL);   
    float* outbx = (float*) mxGetData(pl[0]);
    for(int i=0; i<n_bx; i++) {
        outbx[ i + 0*n_bx ] = (float) boxes[i].c+1;
        outbx[ i + 1*n_bx ] = (float) boxes[i].r+1;
        outbx[ i + 2*n_bx ] = (float) boxes[i].w;
        outbx[ i + 3*n_bx ] = (float) boxes[i].h;
        outbx[ i + 4*n_bx ] = boxes[i].s;
    }
}
