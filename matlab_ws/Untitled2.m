%����ϵͳ�Ŀ���������Ƶ������������
 
%%%   ʹ�÷���    %%%
 
%>> G1 = tf(2,[conv([2,1],[8,1])]);
 
%>> w = 10e-3:0.1:100;
 
%>> [x1,y1] = bd_asymp(G1,w);
 
%>> semilogx(x1,y1);
 
 
% ��func�Ļ���������
 
% step1�������ݺ���ת��Ϊ�㼫����ʽ
 
% step2�������ж�ϵͳ�����ͼ��㣬���ҽ�����Ƶ�ʴ���б�ʱ仯һһ��Ӧ
 
% step3���Խ���Ƶ���Լ�����Ƶ�ʶ�Ӧ��б�ʽ�������
 
% step4���������Ƶ�ʶ�Ӧ�ķ��ȣ�������
 
function[wpos,ypos]=bd_asymp(G,w)
 
G1=zpk(G);%��ϵͳת��ΪZero Pole Gain��ʽ
 
wpos=[];
 
pos1=[];
 
%�����funcֻ�д��ݺ���һ���������������freqint2�����Զ�����Ƶ�ʷ�Χ
 
%freqint2��Nyquist and Nichols��ͼ���Զ����ڷ�Χ�ĺ���
 
%nargin��ȷ������������
 
if nargin==1,w=freqint2(G);
 
end
 
zer=G1.z{1}; pol=G1.p{1};gain=G1.k;
 
for i=1:length(zer)  %�����ж�ϵͳ�����
 
    if isreal(zer(i)) %ȷ��һ��΢�ֻ��ڵĽ���Ƶ�ʣ�
 
        wpos=[wpos,abs(zer(i))];
 
        pos1=[pos1,20];%ÿ��һ��һ��΢�ֻ��ڣ�������б��+20
 
    else
 
        if imag(zer(i))>0 %ȷ������΢�ֻ��ڵĽ���Ƶ��
 
            wpos=[wpos,abs(zer(i))];
 
            pos1=[pos1,40];%ÿ��һ������΢�ֻ��ڣ�������б��+40
 
        end
 
    end
 
end
 
for i=1:length(pol) %�����ж�ϵͳ�ļ���
 
    if isreal(pol(i))%ȷ�����Ի��ںͻ��ֻ��ڵĽ���Ƶ��
 
    wpos=[wpos,abs(pol(i))];
 
    pos1=[pos1,-20];%ÿ��һ�����Ի��ڻ��߻��ֻ��ڣ�������б��-20
 
    else
 
        if imag(pol(i))>0
 
            wpos=[wpos,abs(pol(i))]; %ÿ��һ���񵴻��ڣ�������б��-40
 
            pos1=[pos1,-40];
 
        end
 
    end
 
end
 
wpos=[wpos w(1) w(length(w))];%������������������Ļ���������������Ƶ�ʾ���function֮ǰ�����Ƶ�ʷ�Χ
 
pos1=[pos1,0,0];%Ϊ�˺�wpos��С����ƥ�䣬������Ƶ�ʷ�Χ���˲��ı�б��
 
[wpos,ii]=sort(wpos);%�Խ���Ƶ�ʽ�������ii�ǽ���Ƶ�ʵ����
 
pos1=pos1(ii);%���ս���Ƶ�ʵ�˳�򣬶�Ӧ�Ľ���б�ʵ�����
 
ii=find(abs(wpos)<eps); %����С��0(eps����С����������)�Ľ���Ƶ�ʵ������������ж�ϵͳ�Ľ���
 
kslp=0;%����б��
 
w_start=1000*eps;%���忪ʼƵ��,���˹��󣬷�ֹ�ؼ���ֵȱʧ�����˹�С����ֹ������ʵƵ�ʲ������
 
if ~isempty(ii)   %�ж��ǲ���0��ϵͳ
 
    kslp=sum(pos1(ii));%ȷ����ʼб��
 
    ii=(ii(length(ii))+1):length(wpos);%��Ϊ�ڴ�֮ǰ�Ѿ��Խ���Ƶ�ʽ���������������ѡȡ�������Ľ���Ƶ��
 
    wpos=wpos(ii);%�����������󵽵�ʵ�ʵĽ���Ƶ��
 
    pos1=pos1(ii);%�����������󵽵�ʵ�ʽ���Ƶ�ʶ�Ӧ��б�ʱ仯
 
end
 
while 1
 
    [ypos1,~]=bode(G,w_start);%��ȡ��Ԥ��ĵ�һ��Ƶ�ʿ�ʼ�Ĳ���ͼ�ķ��Ⱥ����
 
    if isinf(ypos1)
 
        w_start=w_start*10;%�����Ӧ�ķ���ֵ�����򽫿�ʼƵ��*10���������ƶ�һ���̶ȣ�����ѡһ�������㽥���ߵ����
 
    else
 
        break;
 
    end
 
end
 
wpos=[w_start wpos];%����ȷ������ʼƵ�ʵĴ�С���ڽ���Ƶ��֮ǰ��һ����ʼƵ��
 
ypos(1)=20*log10(ypos1);%����ȷ������ʼƵ�ʶ�Ӧ�ķ���
 
pos1=[kslp pos1]; %����ȷ������ʼб��
 
for i=2:length(wpos)
 
    kslp=sum(pos1(1:i-1));%�������е�б�ʱ仯֮��
 
    ypos(i)=ypos(i-1)+kslp*log10(wpos(i)/wpos(i-1));%����б�ʺ���������Ƶ�������һ������Ƶ�ʶ�Ӧ�ķ���
 
end
 
ii=find(wpos>=w(1)&wpos<=w(length(w)));%ѡȡ�ڹ涨Ƶ�ʷ�Χ�ڵĽ���Ƶ��
 
wpos=wpos(ii);
 
ypos=ypos(ii); %func��󷵻ؽ���Ƶ���Լ���Ӧ�ķ���