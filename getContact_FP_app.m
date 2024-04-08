function Y = getContact_FP_app(F, treshold, standard)
pat = F > treshold;
vd = diff([0 pat 0]);
starts = find(vd == 1);
ends = find(vd == -1); 
[longest_streak, idx] = max(ends-starts);
location = starts(idx);
locationend = ends(idx);
if nargin == 3
    [~,indmaxF] = max(F);
    for i = indmaxF:-1:1
        if F(i) < treshold
            C(1) = i;
            break
        end
    end
    
    for i = indmaxF:1:length(F)
        if F(i) < treshold
            C(2) = i;
            break
        end
    end
    Contact = C(1):C(2);
else
    
    
    C = find(F>treshold);
    if size(F, 1) > size(F, 2)
        D(:,1) = find(diff(C) > 1);
    else
        D(:,1) = find(diff(C) > 1)';
    end
    if ~isempty(D)
        if length(D) == 1
            if D/length(C) < 0.5
                Contact = C(D+1)  :  C(end);
            else
                Contact = C(1)   :  C(D+1);
            end
        else
            Abst(1) = D(1) ;
            for i = 1:length(D)-1
                Abst(i+1) = D(i+1) - D(i);
            end
            Abst(i+2) = C(end) - (C(1)+ D(i+1));
            
            [max_Abst, ind_max_Abst] = max(Abst);
            
            D = [0;D];
            try
                Contact = C(D(ind_max_Abst)+1)  : C(D(ind_max_Abst+1)+1);
            catch
                Contact = C(D(ind_max_Abst)+1)  : C(end);
            end
            
        end
    else
        Contact = C;
    end
end
% Y = Contact;
Y = location:locationend;
alf = 2; 