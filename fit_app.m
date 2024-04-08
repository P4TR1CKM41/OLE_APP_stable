function OUT = fit_app(M1, M2)
% Matrix M1 wird auf die Länge von Vektor M2 gebracht
if size(M1,1) == 1
    if size(M1, 3) == 1
        l1 = size(M1,2);
        l2 = size(M2,2);
        OUT = interp1(1:l1, M1, 1 : (l1-1)/(l2-1) : l1, 'spline');

    else
       l1 = size(M1,3);
       l2 = size(M2,2);
       for i = 1:l1
           V(1,i) = M1(1,1,i);
       end
       V_long = interp1(1:l1, V, 1 : (l1-1)/(l2-1) : l1, 'spline');
       for i = 1:l2
          OUT(1,1,i) = V_long(1,i); 
       end
    end



end

if size(M1,1) > 1
    if size(M1, 3) == 1
        for k = 1:size(M1,1)

            l1(k) = size(M1(k,:),2);
            l2(k) = size(M2,2);
            OUT(k,1:length([1 : (l1-1)/(l2-1) : l1])) = interp1(1:l1, M1(k,:), 1 : (l1-1)/(l2-1) : l1, 'spline');

        end



    end

    if size(M1, 3) > 1
        l1 = size(M1,1);
        l2 = size(M1,2);
        l3 = size(M1,3);
        l6 = length(M2);
        for i = 1:l1
            for j = 1:l2
                V = drehen(M1(i,j,:));
                OUT(i,j,:) = interp1(1:l3, V, 1 : l3/l6 : l3+1, 'spline');

                clear V
            end
        end
    end
end

