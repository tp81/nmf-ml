% Basic example of how to use the NMF_ML algorithm for image unmixing.
%
% Thomas Pengo, June 18th 2013 
%
% Requires DipImage (www.dipimage.org). Uncomment and change the following 
% two lines accordingly after installing.
%
% addpath C:\Program' Files'\DIPimage' 2.4.1'\
% dipstart
%

% Create F1 and F2
dsk = rr<5;
m = dsk | resample(1*dsk,1,[-20 -20])>0;

% Generate two 'concentration' images
F1 = noise(1000*dsk+10,'poisson',1);
F2 = noise(resample(1000*dsk+10,1,[-20 -20]),'poisson',1);
im = dip_image({F1 F2});
joinchannels('RGB',im)

% Mixing matrix
A = [1 0;.5 1];

% 'Concentration' matrix, ground truth
H = [double(F1(m));double(F2(m))];

% Mix signals
Y = A*H;

% Mixed images
F1_ = newim; F1_(m)=Y(1,:);
F2_ = newim; F2_(m)=Y(2,:);
im_ = dip_image({F1_ F2_});
joinchannels('RGB',im_)

% Unmix images
[A H xts] = NMF_ML(Y,m);

% Unmixed images
F1e = newim; F1e(m)=H(1,:);
F2e = newim; F2e(m)=H(2,:);
ime = dip_image({F1e F2e});
joinchannels('RGB',ime)
