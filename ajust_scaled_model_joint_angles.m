function ajust_scaled_model_joint_angles(model_file, IK_res_path, IK_res_angles)
import org.opensim.modeling.*
hoch =1;
model = Model(model_file);
names = IK_res_angles.Properties.VariableNames;
for i = 1 : length (names)
    tempjoint = split(names{1, i}  , '/');
    if contains((names{1, i}), 'jointset') ==1 && contains((names{1, i}), 'value') ==1 
        (names{1, i});
        if contains((names{1, i}), 'pelvis') 
            idx_use = 4;
        else
            idx_use=4;
        end
        index_in_file(hoch,1) = i;
        jointanglenamefromfile{hoch} = tempjoint{4, 1}  ; 
        angles(hoch,1) = IK_res_angles.(i); 
        hoch = hoch+1;
    else
    end
end

%% now get the index of
hoch=1;
for m = 0 : 1000
    try
        worked(hoch,1) = m;
        nameinmodel{hoch} = string( model.getCoordinateSet().get(m));
        hoch = hoch+1;
    catch
    end
end
l = 1;
for u = 0: length (nameinmodel)-1

idx_angles = find(strcmp(jointanglenamefromfile, nameinmodel{1, l}));
model.getCoordinateSet().get(u).set_default_value((angles(idx_angles)) ) ;
l = l+1;
end
model.print(model_file);

end