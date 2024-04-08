     function [Trial_opti] = SVDopti_app(Trial_raw,Ref)
                % Optimizes marker trajectories to better comply with rigid body
                % assumptions.
                
                %____________________________________________________________________
                %% Segment mit 3 Markern
                if size(Ref,2)==3
                    
                    %%
                    Trial=Trial_raw;
                    
                    
                    %% Allg. Paper der Methode: Söderkvist 1993, J. Biomech, s. 1473 bis 1477
                    
                    % Technical-Frame und Barrycenter für Trial erstellen
                    oTrial(:,1,:)=(Trial(:,1,:)+Trial(:,2,:)+Trial(:,3,:))/3;
                    y=repmat(oTrial,1,size(Trial,2));
                    tech_Trial= Trial-y;
                    
                    % Technical-Frame und Barrycenter für Ref erstellen und Mittelwerte dieser
                    oRef(:,1,:)=(Ref(:,1,:)+Ref(:,2,:)+Ref(:,3,:))/3;
                    y2=repmat(oRef,1,size(Ref,2));
                    tech_Refh= Ref-y2;
                    oRefh(:,:)=oRef(:,1,:);
                    oRefm=mean(oRefh,2);
                    tech_Ref=mean(tech_Refh,3);
                    
                    
                    
                    % Cross-Dispersionsmatrix: Arun 1987, IEEE TRANSACTIONS ON PATTERN ANALYSIS
                    % AND MACHINE INTELLIGENCE, s. 698 - 700
                    
                    for i=1:size(Trial,3)
                        G(:,:,i)=tech_Trial(:,:,i)*tech_Ref'; %#ok<AGROW>
                    end
                    clear i
                    
                    
                    % Singulärwertzerlegung % Optimal nach Hanson and Norris (1981, 363) in
                    % SIAM J. Sci. Stat. comput.
                    for i=1:size(Trial,3)
                        
                        [U,~,V] = svd(G(:,:,i));
                        v=[1 1 (det(U'*V))'];
                        R(:,:,i)=U*(diag(v))*V'; %#ok<AGROW>
                        
                        d(:,i)=oTrial(:,1,i)-R(:,:,i)*(oRefm); %#ok<AGROW>
                        clear U  V v
                        
                        %Globale Variable des Trials optimiert rekonstruieren
                        Vektor_1(:,i)=R(:,:,i)*Ref(:,1)+d(:,i); %#ok<AGROW>
                        Vektor_2(:,i)=R(:,:,i)*Ref(:,2)+d(:,i); %#ok<AGROW>
                        Vektor_3(:,i)=R(:,:,i)*Ref(:,3)+d(:,i); %#ok<AGROW>
                    end
                    clear G U S V i v
                    
                    %% Output der Funktion
                    Trial_opti(:,1,:)=Vektor_1;
                    Trial_opti(:,2,:)=Vektor_2;
                    Trial_opti(:,3,:)=Vektor_3;
                    
                    clear G U S V i v
                    
                    
                    %% gefilterter Trial für Plot Aufbereitet
                    vek1(:,:)=Trial_raw(:,1,:);
                    vek2(:,:)=Trial_raw(:,2,:);
                    vek3(:,:)=Trial_raw(:,3,:);
                    
                    
                    %%
                    clear G U S V i v Test_a Test_b A B r R1h R1hs R2h R2hs R3h R3hs
                    clear tech_Refh y y2 yy yyy oRefh
                end
                
                
                
                
                %____________________________________________________________________
                %% Segment mit 4 Markern
                
                
                if size(Ref,2)==4
                    
                    %%
                    Trial=Trial_raw;
                    
                    
                    %% Allg. Paper der Methode: Söderkvist 1993, J. Biomech, s. 1473 bis 1477
                    
                    % Technical-Frame und Barrycenter für Trial erstellen
                    oTrial(:,1,:)=(Trial(:,1,:)+Trial(:,2,:)+Trial(:,3,:)+Trial(:,4,:))/4;
                    y=repmat(oTrial,1,size(Trial,2));
                    tech_Trial= Trial-y;
                    
                    % Technical-Frame und Barrycenter für Ref erstellen und Mittelwerte dieser
                    oRef(:,1,:)=(Ref(:,1,:)+Ref(:,2,:)+Ref(:,3,:)+Ref(:,4,:))/4;
                    y2=repmat(oRef,1,size(Ref,2));
                    tech_Refh= Ref-y2;
                    oRefh(:,:)=oRef(:,1,:);
                    oRefm=mean(oRefh,2);
                    tech_Ref=mean(tech_Refh,3);
                    
                    
                    
                    % Cross-Dispersionsmatrix: Arun 1987, IEEE TRANSACTIONS ON PATTERN ANALYSIS
                    % AND MACHINE INTELLIGENCE, s. 698 - 700
                    
                    for i=1:size(Trial,3)
                        G(:,:,i)=tech_Trial(:,:,i)*tech_Ref';
                    end
                    clear i
                    
                    
                    % Singulärwertzerlegung % Optimal nach Hanson and Norris (1981, 363) in
                    % SIAM J. Sci. Stat. comput.
                    for i=1:size(Trial,3)
                        
                        [U,~,V] = svd(G(:,:,i));
                        v=[1 1 (det(U'*V))'];
                        R(:,:,i)=U*(diag(v))*V';
                        
                        d(:,i)=oTrial(:,1,i)-R(:,:,i)*(oRefm);
                        clear U  V v
                        
                        %Globale Variable des Trials optimiert rekonstruieren
                        Vektor_1(:,i)=R(:,:,i)*Ref(:,1)+d(:,i);
                        Vektor_2(:,i)=R(:,:,i)*Ref(:,2)+d(:,i);
                        Vektor_3(:,i)=R(:,:,i)*Ref(:,3)+d(:,i);
                        Vektor_4(:,i)=R(:,:,i)*Ref(:,4)+d(:,i); %#ok<AGROW>
                    end
                    clear G U S V i v
                    
                    %% Output der Funktion
                    Trial_opti(:,1,:)=Vektor_1;
                    Trial_opti(:,2,:)=Vektor_2;
                    Trial_opti(:,3,:)=Vektor_3;
                    Trial_opti(:,4,:)=Vektor_4;
                    
                    clear G U S V i v
                    
                    
                    %% gefilterter Trial für Plot Aufbereitet
                    vek1(:,:)=Trial_raw(:,1,:); %#ok<NASGU>
                    vek2(:,:)=Trial_raw(:,2,:); %#ok<NASGU>
                    vek3(:,:)=Trial_raw(:,3,:); %#ok<NASGU>
                    vek4(:,:)=Trial_raw(:,4,:); %#ok<NASGU>
                    
                    
                    
                    %%
                    clear G U S V i v Test_a Test_b A B r R1h R1hs R2h R2hs R3h R3hs
                    clear tech_Refh y y2 yy yyy oRefh
                    
                end
                
                end %SVDopti