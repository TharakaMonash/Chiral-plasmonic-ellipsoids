close all;
clear all;
update_files=true;
validate = false;

%Line styles
dashed_linStyles = {'--o','--+','--*','--<','--s','--d','--^','--v','-->','--p','--x','--h'};
linStyles = {'-o','-+','-*','-<','-s','-d','-^','-v','->','-p','-x','-h'};
plotcount =0;


%% Analylitical Results
lambda = 400:1:1200;
% Au permittivity
for j = 1:length(lambda)
    [eps1(j), eps2(j)] =  getEpsAuByLambda(lambda(j), 10e3);
end
e_Au = eps1 + 1i*eps2;

%Background permittivity
e_w =1.75;
% Outer dimensions of chiral Nanorod
apect_ratio= 0.1:0.01:0.9;
%LengthArray = 30*ones(1,length(apect_ratio));
%WidthArray = LengthArray.*apect_ratio;
WidthArray = 10*ones(1,length(apect_ratio));
LengthArray = WidthArray./apect_ratio;
LAAAA=LengthArray;
NoOdEllipsoids=1e12;
% Array initialisation
Absall=zeros(length(apect_ratio),length(lambda));
CDall=zeros(length(apect_ratio),length(lambda));
% Chirality parameter
[CL,e_c] = calcChiralParam(lambda);
%maxwell garnett to get effective medium parameters
frac =0.05;
e_eff = e_Au .*(2*frac*(-e_Au+e_c)+e_c+2*e_Au)./(e_c+2*e_Au-frac*(e_c-e_Au));
CL_modified = 3*frac*(CL.*e_Au./(e_c+2*e_Au-frac*(e_c-e_Au)));

linStyles = {'-o','-+','-*','-<','-s','-d','-^','-v','->','-p','-x','-h'};


%%
Folderpath = "C:\PhD Research\Ellipsoid chiral\ExactChiralEllipsoid\Codes\Matlab\JPLC\othershapes\";
Filenames = ["cylinder_30_10.csv","cylinder_40_10.csv","cylinder_50_10.csv"];

h = zeros(1,2*length(Filenames));
k = zeros(1,2*length(Filenames));

colors=[         
    0    0.4470    0.7410
    0.8500    0.3250    0.0980
    0.9290    0.6940    0.1250
    0.4940    0.1840    0.5560
    0.4660    0.6740    0.1880
    0.3010    0.7450    0.9330
    0.6350    0.0780    0.1840];
linStyles = {'--o','--+','--*','--<','--s','-d','-^','-v','->','-p','-x','-h'};
linStyles_dotted = {'-o','-+','-*','-<',':s',':d',':^',':v',':>',':p',':x',':h'};

lambda_comsol=zeros(121,length(Filenames));
ABSL_comsol=zeros(121,length(Filenames));
ABSR_comsol=zeros(121,length(Filenames));
CD_comsol=zeros(121,length(Filenames));

for i=1:length(Filenames)
    Filepath = strcat(Folderpath,Filenames(i));
    comsolResultsTable = readtable(Filepath);
    comsolResultsArray = table2array(comsolResultsTable(1:121,1:5));
    lambda_comsol(:,i) =comsolResultsArray(:,1).*10^9;
    ABSL_comsol(:,i)=(2*comsolResultsArray(:,2)+comsolResultsArray(:,4))/3;%/max((comsolResultsArray(:,2)+comsolResultsArray(:,4)));
    ABSR_comsol(:,i)=(2*comsolResultsArray(:,3)+comsolResultsArray(:,5))/3;%/max((comsolResultsArray(:,3)+comsolResultsArray(:,5)));
    CD_comsol(:,i)=-ABSL_comsol(:,i)+ABSR_comsol(:,i);
end

ABSscale_comsol=max(max(ABSL_comsol));

CDscale_comsol=max(max(CD_comsol));

subplot(2,2,3)
for i=1:1:length(Filenames)
        plot(lambda_comsol(:,i), ABSL_comsol(:,i)/ABSscale_comsol,strcat(linStyles_dotted{i}),'color',colors(i,:),'LineWidth',1,'MarkerIndices',1:10:length(lambda_comsol(:,i)));
        hold on
end


xlabel("Wavelength (nm)");
ylabel("Absorption (arb. units)");

subplot(2,2,4)
for i=1:1:length(Filenames)
        plot(lambda_comsol(:,i), CD_comsol(:,i)/CDscale_comsol,strcat(linStyles_dotted{i}),'color',colors(i,:),'LineWidth',1,'MarkerIndices',1:10:length(lambda_comsol(:,i)));
        hold on%,
end
xlabel("Wavelength (nm)");
ylabel("CD (arb. units)");
% Outer dimensions of chiral Nanorod
LengthArray = [38,48,58];
Width = 10;

subplot(2,2,1)
ellipsoid(0,20,0,5,5,19)
axis equal
hold on
%cylinder(5)
[x,y,z] = cylinder(5);
%x=x-20;
z(1, :) = -15;
z(2, :) = 15;
surf(x,y,z);
hold on 

[x, y] = ndgrid(linspace(-15,15,500));
z = cos(2*pi*(x+y)*2)*0+15;
z(x.^2+y.^2>25) = NaN; %// remove values outside unit circle
surf(x,y,z,'edgecolor','none')
axis equal

view(-60,30)
colormap('copper')
shading interp
lightangle(-45,30)

xlabel("X (nm)");
ylabel("Y (nm)");
zlabel("Z (nm)");
% Array initialisation
AbsallV=zeros(length(LengthArray),length(lambda));
CDallV=zeros(length(LengthArray),length(lambda));

for count=1:1:length(LengthArray)
    Length= LengthArray(count);
    [AbsL,AbsR]= calcAbsN(e_w, lambda, e_eff, Length/2, Width/2, CL_modified,NoOdEllipsoids);
    AbsallV(count,:)=AbsL%/max(AbsL);
    CD = AbsR-AbsL;
    CDallV(count,:)=CD;
end
abscaleV=max(max(AbsallV));
cdcaleV=max(max(CDallV));

subplot(2,2,3)
for i=1:1:length(LengthArray)
    plot(lambda, AbsallV(i,:)/abscaleV,strcat(linStyles{i}),'color',colors(i,:),'LineWidth',1,'MarkerIndices',1:50:length(lambda_comsol(:,i)));
    hold on
end
xlim([400,1000]);
ylim([0,1]);

% subplot(1,2,2)
% for i=1:1:length(LengthArray)
%     plot(lambda, AbsallV(i,:)/abscaleV,strcat(linStyles{i}),'color',colors(i,:),'LineWidth',1,'MarkerIndices',1:50:length(lambda_comsol(:,i)));
%     hold on
% end
% xlim([400,1000]);
% ylim([0,1]);


% subplot(3,2,1)
% for i=1:1:length(LengthArray)
%     plot([400,1200], [Width/LengthArray(i),Width/LengthArray(i)],'--','color',colors(i,:),'LineWidth',1);
%     hold on
% end

subplot(2,2,4)
for i=1:1:length(LengthArray)
    plot(lambda, CDallV(i,:)/cdcaleV,strcat(linStyles{i}),'color',colors(i,:),'LineWidth',1,'MarkerIndices',1:50:length(lambda_comsol(:,i)));
    hold on
end
xlim([400,1000]);

% subplot(3,2,3)
% for i=1:1:length(LengthArray)
%     plot([400,1200], [Width/LengthArray(i),Width/LengthArray(i)],'--','color',colors(i,:),'LineWidth',1);
%     hold on
% end
subplot(2,2,2)
aa=[30,40,50];
bb=[10,10,10];
for i=1:1:length(LengthArray)
    a=aa(i); % horizontal radius
    b=bb(i); % vertical radius
    x=[-a/2,-a/2,a/2,a/2,-a/2];
    y=[-b/2,b/2,b/2,-b/2,-b/2]+2*Width*(i-2);
    plot(y,x,'color',colors(i,:),'LineWidth',1)
    hold on
end
%xlim([-60,60]);
%ylim([-60,60]);

for i=1:1:length(LengthArray)
    a=LengthArray(i)/2; % horizontal radius
    b=Width/2; % vertical radius
    x0=0; % x0,y0 ellipse centre coordinates
    y0=2*Width*(i-2);
    t=-pi:0.01:pi;
    x=x0+a*cos(t);
    y=y0+b*sin(t);
    plot(y, x,'--','color',colors(i,:),'LineWidth',1)
    hold on
end
%axis equal
xlim([-60,60]);
ylim([-35,35]);
xlabel("X (nm)");
ylabel("Z (nm)");

set(gcf,'units','inches','position',[0.5,0.5,6.25,3])
set(findall(gcf,'-property','FontSize'),'FontSize',9)
set(findall(gcf,'-property','LineWidth'),'LineWidth',1)
set(findall(gcf,'-property','FontName'),'FontName','Arial')

subplot(2,2,1)
set(gca,'units','inches','position',[0.425,1.75,2.5,1])
text(410,0.9,'(A)')%'fontweight', 'bold'
leg.Position=[5.5, 3.25, 0.5, 1.25];
subplot(2,2,2)
set(gca,'units','inches','position',[3.5,1.75,2.5,1])
text(410,0.9,'(B)')
subplot(2,2,3)
set(gca,'units','inches','position',[0.425,0.375,2.5,1])
text(410,0.8,'(C)','Color','white')
subplot(2,2,4)
set(gca,'units','inches','position',[3.5,0.375,2.5,1])
text(410,0.9,'(D)')
% subplot(3,2,5)
% set(gca,'units','inches','position',[0.425,0.375,2.2,1])
% text(410,0.8,'(E)','Color','white')
% subplot(3,2,6)
% set(gca,'units','inches','position',[3.85,0.375,2.2,1])
% text(410,0.9,'(F)')

set(findall(gcf,'-property','FontSize'),'FontSize',9)
set(findall(gcf,'-property','FontName'),'FontName','Arial')
%print('Fig_3_orientation_aspect_ratio_2','-depsc', '-painters', '-r600');


