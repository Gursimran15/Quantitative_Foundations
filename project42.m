function project42()
    faces = readfaces();
    [subjects, images] = size(faces);
    eigfaces = cell(subjects, images);
    pcainput = zeros(400, 92*112);
    img = 1;
    export = false; % whether or not to export the images used in the report
    
    for s = 1:subjects % retrieve images for pca processing.
        for i = 1:images
            facePair = faces(s,i);
            facePair = facePair{1};
            face = facePair{1};
            pcainput(img,:) = reshape(face, [1, 92*112]);
            img = img + 1;
        end        
    end
    
    [P,Y,~] = pcacode(pcainput, 1);
    first = 5;
    for i = 1:first
        subplot(1,first, i);
        f = myreshape(Y(i,:));
        imshow(f,[]);
    end
    a = gcf;
    if export
        exportgraphics(a,'eigenfaces.png','Resolution',300);
    end
    figure;
    
    %****************************************
    targets = [1, 3, 20, 35]; % subjects to pick out
    t_images = [1,5]; % images from each subject to pick.
    pcss = [10, 20, 50, 100, 150, 200, 400]; % number of components to calculate
    %****************************************
    
    reconstructed_images = zeros(length(pcss), length(targets), length(t_images), 92*112 );
    for p = 1:length(pcss) % this loop reconstructs images.
        pcs = pcss(p);
        [P,Y,~] = pcacode(pcainput, 1);
        y = P(:, 1:pcs)*Y(1:pcs, :) + mean(pcainput,2) * ones(1, size(pcainput, 2));
        for t = 1:length(targets)
            subject_base = ((targets(t) - 1) * 10); % index offset into pcainput/ y for target subject
            for im = 1:length(t_images)
                   reconstructed_images(p,t,im, :) = y(subject_base + t_images(im), :);
            end      
        end       
    end
    i = 1;
    w = length(targets) * length(t_images);
    h = length(pcss) + 1;
    for t = 1:length(targets) % this loop makes the figure of reconstructed images.
        subject_base = ((targets(t) - 1) * 10); % index offset into pcainput/ y for target subject
        for im = 1:length(t_images)
            for p = 1:length(pcss)
                a = subplot_tight(h, w, sub2ind([w,h], im + (length(t_images) * (t - 1)), p ),0.02);
                f = myreshape( reconstructed_images(p,t,im,:) );
                imshow(f,[]);
                if t == 1 && im == 1
                    ylabel("Components: " + num2str(pcss(p)));
                end
                i = i + 1;
            end
            subplot_tight(h, w, sub2ind([w,h], im + (length(t_images) * (t - 1)), h ),0.02);
            f = myreshape( reconstructed_images(p,t,im,:) );
            imshow(f,[]);
            if t == 1 && im == 1
                ylabel("Original");
            end
        end
    end
    %****************************************
    x0=10;
    y0=10;
    width=1100;
    height=800;
    set(gcf,'position',[x0,y0,width,height])
    %****************************************
    if export
        exportgraphics(gcf,'reconstruction.png','Resolution',300);
    end

    % PART 2
    
    % make training and test sets.
    nonface_images= readnonfaces();
    [nf_num, ~] = size(nonface_images);
    test_nonface = 1:1:5;
    % set and label construction
    test_subjects = [36, 37, 38, 39, 40]; % should be 5 subjects for test set.
    withhold_images = [5, 8]; % images put into the test set.
    test_set_n = (10 * 5) + (2 * 35) + length(test_nonface);
    test_set = zeros(test_set_n, 92*112);
    test_labels_classify = zeros(test_set_n, 1);
    test_labels_binary = zeros(test_set_n, 1); % first index is non face, second is face.
    
    training_nonface = 6:1:15;
    training_subjects = 1:1:35;
    training_selection = [1,2,3,4,6,7,9,10];
    train_set_n = length(training_subjects) * length(training_selection) + length(training_nonface);
    training_set = zeros(train_set_n, 92*112);
    training_labels_classify = zeros(train_set_n, 1);
    training_labels_binary = zeros(train_set_n, 1); % first index is non face, second is face.
    
    % filling test and training sets
    ti = 1;
    for su = 1:length(training_subjects) % fill the training set
        s = training_subjects(su);
        subject_offset = 10*(s - 1); % s == 1 => 10*0 = 0 ||| s == 2 => 10 ( 2 - 1) = 10
        for i = 1:length(training_selection)
           training_set(ti, :) = pcainput(subject_offset + training_selection(i), :);
           training_labels_classify(ti) = s;
           training_labels_binary(ti) = 2;
           ti = ti + 1;
        end
    end
    for i = 1:length(training_nonface) % don't forget nonface images...
       im = training_nonface(i);
       training_set(ti, :) = nonface_images(im, :);
       training_labels_classify(ti) = 41;
       training_labels_binary(ti) = 1;
       ti = ti + 1;
    end
    
    ti = 1;
    for s = 1:40 % fill the test set
        subject_offset = 10*(s - 1); % s == 1 => 10*0 = 0 ||| s == 2 => 10 ( 2 - 1) = 10
        if ismember(s ,test_subjects) % do we take all or only two images?
            for i = 1:10 % all!
                test_set(ti, :) = pcainput(subject_offset + i, :);
                test_labels_classify(ti) = s;
                test_labels_binary(ti) = 2;
                ti = ti + 1;
            end
        else
            for i = 1:length(withhold_images) % only two!
                test_set(ti, :) = pcainput(subject_offset + withhold_images(i), :);
                test_labels_classify(ti) = s;
                test_labels_binary(ti) = 2;
                ti = ti + 1;
            end
        end
    end
    for i = 1:length(test_nonface) % don't forget nonface images...
       im = test_nonface(i);
       test_set(ti, :) = nonface_images(im, :);
       test_labels_classify(ti) = 41;
       test_labels_binary(ti) = 1;
       ti = ti + 1;
    end
    
    %perform classification/ identification!
    part1_labels = lrclassification(training_set', training_labels_binary, test_set', 1, 200);
    part2_labels = lrclassification(training_set', training_labels_classify, test_set', 2, 100);  
    disp("Binary classification accuracy with expansion == 1, and # of principal components == 200: " + num2str(accuracy(part1_labels, test_labels_binary)) );
    disp("Multi-class identification accuracy with expansion == 2, and # of principal components == 100: " + num2str(accuracy(part2_labels, test_labels_classify)) );

end

function img = myreshape(i)
    img = reshape(i, [112,92]);
end
function acc = accuracy(data, truth)
    acc = sum(data == truth') / length(data);
end
function vargout=subplot_tight(m, n, p, margins, varargin)
%% subplot_tight
% A subplot function substitude with margins user tunabble parameter.
%
%% Syntax
%  h=subplot_tight(m, n, p);
%  h=subplot_tight(m, n, p, margins);
%  h=subplot_tight(m, n, p, margins, subplotArgs...);
%
%% Description
% Our goal is to grant the user the ability to define the margins between neighbouring
%  subplots. Unfotrtunately Matlab subplot function lacks this functionality, and the
%  margins between subplots can reach 40% of figure area, which is pretty lavish. While at
%  the begining the function was implememnted as wrapper function for Matlab function
%  subplot, it was modified due to axes del;etion resulting from what Matlab subplot
%  detected as overlapping. Therefore, the current implmenetation makes no use of Matlab
%  subplot function, using axes instead. This can be problematic, as axis and subplot
%  parameters are quie different. Set isWrapper to "True" to return to wrapper mode, which
%  fully supports subplot format.
%
%% Input arguments (defaults exist):
%   margins- two elements vector [vertical,horizontal] defining the margins between
%        neighbouring axes. Default value is 0.04
%
%% Output arguments
%   same as subplot- none, or axes handle according to function call.
%
%% Issues & Comments
%  - Note that if additional elements are used in order to be passed to subplot, margins
%     parameter must be defined. For default margins value use empty element- [].
%  - 
%
%% Example
% close all;
% img=imread('peppers.png');
% figSubplotH=figure('Name', 'subplot');
% figSubplotTightH=figure('Name', 'subplot_tight');
% nElems=17;
% subplotRows=ceil(sqrt(nElems)-1);
% subplotRows=max(1, subplotRows);
% subplotCols=ceil(nElems/subplotRows);
% for iElem=1:nElems
%    figure(figSubplotH);
%    subplot(subplotRows, subplotCols, iElem);
%    imshow(img);
%    figure(figSubplotTightH);
%    subplot_tight(subplotRows, subplotCols, iElem, [0.0001]);
%    imshow(img);
% end
%
%% See also
%  - subplot
%
%% Revision history
% First version: Nikolay S. 2011-03-29.
% Last update:   Nikolay S. 2012-05-24.
%
% *List of Changes:*
% 2012-05-24
%  Non wrapping mode (based on axes command) added, to deal with an issue of disappearing
%     subplots occuring with massive axes.
%% Default params
isWrapper=false;
if (nargin<4) || isempty(margins)
    margins=[0.04,0.04]; % default margins value- 4% of figure
end
if length(margins)==1
    margins(2)=margins;
end
%note n and m are switched as Matlab indexing is column-wise, while subplot indexing is row-wise :(
[subplot_col,subplot_row]=ind2sub([n,m],p);  
height=(1-(m+1)*margins(1))/m; % single subplot height
width=(1-(n+1)*margins(2))/n;  % single subplot width
% note subplot suppors vector p inputs- so a merged subplot of higher dimentions will be created
subplot_cols=1+max(subplot_col)-min(subplot_col); % number of column elements in merged subplot 
subplot_rows=1+max(subplot_row)-min(subplot_row); % number of row elements in merged subplot   
merged_height=subplot_rows*( height+margins(1) )- margins(1);   % merged subplot height
merged_width= subplot_cols*( width +margins(2) )- margins(2);   % merged subplot width
merged_bottom=(m-max(subplot_row))*(height+margins(1)) +margins(1); % merged subplot bottom position
merged_left=min(subplot_col)*(width+margins(2))-width;              % merged subplot left position
pos=[merged_left, merged_bottom, merged_width, merged_height];
if isWrapper
   h=subplot(m, n, p, varargin{:}, 'Units', 'Normalized', 'Position', pos);
else
   h=axes('Position', pos, varargin{:});
end
if nargout==1
   vargout=h;
end
end
function testlabel = lrclassification(traindata, trainlabel, testdata,p,pcsss)
[P,PY,~] = pcacode(traindata', 1);
% [P,PPY,~] = pcacode(testdata', 1);
% Y(1:pcs, :)' 

traindata = traindata' * PY(1:pcsss,:)';
traindata = traindata';
testdata = testdata' * PY(1:pcsss,:)';
testdata = testdata';

ntrain = length(trainlabel);
nclass = length(unique(trainlabel));
Y = zeros(nclass,ntrain);
for i=1:ntrain
    Y(trainlabel(i),i) = 1;
end

X = poly_expand(traindata,p);
W = Y*X'*inv(X*X');

Xtest = poly_expand(testdata,p);
Ytest = W*Xtest;

ntest = size(testdata,2);
testlabel = zeros(1,ntest);

for i=1:ntest
    [c , idx] = max(Ytest(:,i));
    testlabel(i) = idx;
end

% plot(Y(1,:),Y(2,:),"sz.");
% hold on;
% plot(Ytest(1,:),Ytest(2,:),"r.");
% hold on;
end
function [x_poly] = poly_expand(x,p)
x_poly = [];
for i= p:-1:1
    x_poly = [x_poly;x.^i];
end
x_poly = [x_poly;ones(1,size(x,2))];
end
function [P,Y,s] = pcacode(X,op)
[p,n] = size(X);
X = X - mean(X,2)*ones(1,n);
symmat = 0;
P=0;
Y=0;
if(op ==1)
    symmat = X*X'./(n-1);
    %symmat = diff*diff';
    [Er,Ee]=eig(symmat);
    s = diag(Ee);
    [s,idx] = sort(s,'descend');
    tv = sum(s);
    Er = Er(:, idx);
    
    for i=1:length(s)
        per(i)=s(i)/tv;
        tper(i)=sum(per(1:i));
    end
    P = Er;
    %plot(tper,'o');
    %figure;
    %pause;
elseif(op==2)
    symmat = X/sqrt(n-1);
   [U,S,V]= svd(symmat);
    P = U;
    s = diag(S);
    tv = sum(s.^2);
    for i=1:length(s)
        per(i)=s(i).^2/tv;
        tper(i)=sum(per(1:i));
    end
    %plot(tper,'o');
    %pause;
end

Y = P'*X;

end
function imgs = readfaces()
% image size is 92x112
    
    subjects = 40;
    images = 10;
    
    % high dim structure:
    % Rows are subjects
    % Cols are Images
    % imgs ( subject, image_number ) ==> {array of pixel data, subject number}.
    
    imgs = cell(subjects, images, 1);
    for s = 1:subjects
        for i = 1:images
            [IMG, cmap] = imread(".\faces\s"+num2str(s)+"\"+num2str(i)+".pgm");
            %image(IMG);
            [h,w] = size(IMG);
            img = zeros(h,w);
            for j = 1:h
                for k = 1:w
                    img(j,k) = int8(IMG(j,k));
                end
            end
            imgs{s,i,1} = {img, s};
        end
    end
end
function imgs = readnonfaces()
% image size is 92x112
    
    images = 15;
    
    % high dim structure:
    % Rows are subjects
    % Cols are Images
    % imgs ( subject, image_number ) ==> {array of pixel data, subject number}.
    
    imgs = zeros(15, 92*112);

    for i = 0:images-1
        [IMG, cmap] = imread(".\nonface\"+num2str(i)+".ppm");
        %image(IMG);
        [h,w] = size(IMG(:,:,1));
        img = zeros(h,w);
        for j = 1:h
            for k = 1:w
                img(j,k) = int8(IMG(j,k));
            end
        end
        imgs(i+1, :) = reshape(img, [1, 92*112]);
    end
end