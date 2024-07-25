function Watermark_Extraction(WatermarkingImage,watermark0,LL_R_S2,LL_G_S2,LL_B_S2,Scaling_Factor,m2,n2,Level,j,k,l)
global  ExtractWatermark;
global  LL_R_S  LL_G_S LL_B_S;

WatermarkingImage_R=WatermarkingImage(:,:,1);
WatermarkingImage_G=WatermarkingImage(:,:,2);
WatermarkingImage_B=WatermarkingImage(:,:,3);

[psi_R,st_R]= shearletTransformSpect(WatermarkingImage_R,Level);
[psi_G,st_G]= shearletTransformSpect(WatermarkingImage_G,Level);
[psi_B,st_B]= shearletTransformSpect(WatermarkingImage_B,Level);

LL_R_new=psi_R(:,:,j);
LL_G_new=psi_G(:,:,k);
LL_B_new=psi_B(:,:,l);

[LL_R_U,LL_R_S,LL_R_V]=svd(LL_R_new);
[LL_G_U,LL_G_S,LL_G_V]=svd(LL_G_new);
[LL_B_U,LL_B_S,LL_B_V]=svd(LL_B_new);

LL_R=LL_R_U*LL_R_S*LL_R_V';
LL_G=LL_G_U*LL_G_S*LL_G_V';
LL_B=LL_B_U*LL_B_S*LL_B_V';

psi_R(:,:,j)=LL_R;
psi_G(:,:,k)=LL_G;
psi_B(:,:,l)=LL_B;

Extracting_Orginal_Image_R=inverseShearletTransformSpect(psi_R,st_R);
Extracting_Orginal_Image_G=inverseShearletTransformSpect(psi_G,st_G);
Extracting_Orginal_Image_B=inverseShearletTransformSpect(psi_B,st_B);

Extracting_Orginal_Image=cat(3,Extracting_Orginal_Image_R,Extracting_Orginal_Image_G,Extracting_Orginal_Image_B);

SearchAgents_no=30; % Number of search agents
Function_name='F1'; % Name of the test function that can be from F1 to F23 ( 
Max_iteration=100; % Maximum numbef of iterations
% Load details of the selected benchmark function
[lb,ub,dim,fobj]=Get_Functions_details(Function_name);
[Best_score,Best_pos,SSA_cg_curve]=SSA(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);

ExtractWatermark_R=(LL_R_S2-LL_R_S)/Best_pos;
ExtractWatermark_G=(LL_G_S2-LL_G_S)/Best_pos;
ExtractWatermark_B=(LL_B_S2-LL_B_S)/Best_pos;

ExtractWatermark=cat(3,ExtractWatermark_R,ExtractWatermark_G,ExtractWatermark_B);
ExtractWatermark=imresize(ExtractWatermark,[m2,n2]);

PSNR_value_New=PSNR(watermark0,ExtractWatermark);
SSIM_value_New=ssim(watermark0,ExtractWatermark);
NC_value =(sum(sum(sum(watermark0(:,:,:).*ExtractWatermark(:,:,:)))) / ((sqrt(sum(sum(sum(watermark0(:,:,:).^2))))).*(sqrt(sum(sum(sum(ExtractWatermark(:,:,:).^2)))))));
fprintf('%.4f \n%.4f  \n%.4f \n',PSNR_value_New,SSIM_value_New,NC_value)
fprintf('%.4f\n',Best_pos)

end