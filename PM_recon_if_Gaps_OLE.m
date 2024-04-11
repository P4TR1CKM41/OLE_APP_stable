function [MARKERS, Gap_length, marker_recon_name] = PM_recon_if_Gaps_OLE(MARKERS,structname,markernames)


n_markers = length (markernames);
for i =1 : length (markernames)
    MARKERARRYTEMPCELL{1,i} = MARKERS.(structname).Raw.(markernames{1, i}).data';
end
DELETE.MARKERARRYTEMP =  cell2mat(MARKERARRYTEMPCELL); 
DELETE.MARKERARRYTEMP  ((DELETE.MARKERARRYTEMP)  ==0) = NaN;
[DELETE.row, DELETE.col] = find(isnan(DELETE.MARKERARRYTEMP));
DELETE.mG(1,1) =length(find (DELETE.col==1));
DELETE.mG(1,2) =length(find (DELETE.col==4));
DELETE.mG(1,3)=length(find (DELETE.col==7));
if n_markers>=4
    DELETE.mG(1,4) =length(find (DELETE.col==10));
else
end
[Gap_length,DELETE.Inimarker] = max(DELETE.mG); % the marker with the biggest gap
DELETE.ALLmarkerind = [1:length(DELETE.mG)];
DELETE.MarkerindOK =  DELETE.ALLmarkerind(find( DELETE.ALLmarkerind~=DELETE.Inimarker));
[ ReconstructedFullDataSet ] = PredictMissingMarkersOLE(DELETE.MARKERARRYTEMP, [DELETE.MarkerindOK]);
marker_recon_name = markernames{1, find( DELETE.ALLmarkerind==DELETE.Inimarker)}; 
% % % % plot(ReconstructedFullDataSet, 'r')
% % % % hold on
% % % % plot(  DELETE.MARKERARRYTEMP, 'g')


%% before output bring it back to the origianl structure

MARKERS.(structname).Raw.(markernames{1,1}).data = ReconstructedFullDataSet(:,[1:3])';
MARKERS.(structname).Raw.(markernames{1,2}).data = ReconstructedFullDataSet(:,[4:6])';
MARKERS.(structname).Raw.(markernames{1,3}).data = ReconstructedFullDataSet(:,[7:9])';
try
MARKERS.(structname).Raw.(markernames{1,4}).data = ReconstructedFullDataSet(:,[10:12])';
catch
end

end