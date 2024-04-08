function OUT = fit_n(M1, n)
% Matrix M1 wird auf die Länge von n gebracht
if size(M1,1) > 1
    
    if size(M1, 3) == 1
        for z = 1:size(M1,1)
            l1 = size(M1,2);
            l2 = n;
            OUT(z,:) = interp1(1:l1, M1(z,:), 1 : (l1-1)/(l2-1) : l1, 'linear');
        end
    end
    
    
    if size(M1, 3) > 1
        l1 = size(M1,1);
        l2 = size(M1,2);
        l3 = n;
        l6 = length(M2);
        for i = 1:l1
            for j = 1:l2
                V = drehen(M1(i,j,:));
                OUT(i,j,:) = interp1(1:l3, V, 1 : (l3-1)/(l6-1) : l3, 'spline');
                
                clear V
            end
        end
    end


else
    if size(M1, 3) == 1
        l1 = size(M1,2);
        l2 = n;
        OUT = interp1(1:l1, M1, 1 : (l1-1)/(l2-1) : l1, 'spline');
        
    end
    
    
    if size(M1, 3) > 1
        l1 = size(M1,1);
        l2 = size(M1,2);
        l3 = n;
        l6 = length(M2);
        for i = 1:l1
            for j = 1:l2
                V = drehen(M1(i,j,:));
                OUT(i,j,:) = interp1(1:l3, V, 1 : (l3-1)/(l6-1) : l3, 'spline');
                
                clear V
            end
        end
    end
end

