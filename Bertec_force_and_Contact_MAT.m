                          %%% [FP.(structname).COP, FP.(structname).COP_vid,  FP.(structname).GRFfilt,FP.(structname).GRFfilt_vid, FP.(structname).FM, FP.(structname).ind_baseline] = get_treadmill_GRF_GUI_MoTrack([pathname, char(filename(1,i))], OPTIONS, 1);
                          [FP.(structname).COP, FP.(structname).COP_vid,  FP.(structname).GRFfilt,FP.(structname).GRFfilt_vid, FP.(structname).FM, FP.(structname).ind_baseline] = get_treadmill_GRF_GUI_MoTrack_mat(path_to_dyn, OPTIONS, 1);

                            
                            CONTACT.(structname) = getContactTreadmill_MoTrack(FP.(structname), MARKERS.(structname), OPTIONS);
                            FP.(structname).GRFfilt.Right = zeros(size(FP.(structname).GRFfilt.Both));
                            FP.(structname).GRFfilt.Left = zeros(size(FP.(structname).GRFfilt.Both));
                            FP.(structname).COP.Right = zeros(size(FP.(structname).GRFfilt.Both));
                            FP.(structname).COP.Left = zeros(size(FP.(structname).GRFfilt.Both));
                            FP.(structname).FM.Right = zeros(size(FP.(structname).GRFfilt.Both));
                            FP.(structname).FM.Left = zeros(size(FP.(structname).GRFfilt.Both));
                            
                            for w = 1:size(CONTACT.(structname).EVENTS_R,2)
                                FP.(structname).GRFfilt.Right(:,CONTACT.(structname).EVENTS_R(1,w):CONTACT.(structname).EVENTS_R(2,w)) = FP.(structname).GRFfilt.Both(:,CONTACT.(structname).EVENTS_R(1,w):CONTACT.(structname).EVENTS_R(2,w));
                                FP.(structname).COP.Right(:,CONTACT.(structname).EVENTS_R(1,w):CONTACT.(structname).EVENTS_R(2,w)) = FP.(structname).COP.Both(:,CONTACT.(structname).EVENTS_R(1,w):CONTACT.(structname).EVENTS_R(2,w));
                                FP.(structname).FM.Right(:,CONTACT.(structname).EVENTS_R(1,w):CONTACT.(structname).EVENTS_R(2,w)) = FP.(structname).FM.Both(:,CONTACT.(structname).EVENTS_R(1,w):CONTACT.(structname).EVENTS_R(2,w));
                            end
                            
                            for w = 1:size(CONTACT.(structname).EVENTS_L,2)
                                FP.(structname).GRFfilt.Left(:,CONTACT.(structname).EVENTS_L(1,w):CONTACT.(structname).EVENTS_L(2,w)) = FP.(structname).GRFfilt.Both(:,CONTACT.(structname).EVENTS_L(1,w):CONTACT.(structname).EVENTS_L(2,w));
                                FP.(structname).COP.Left(:,CONTACT.(structname).EVENTS_L(1,w):CONTACT.(structname).EVENTS_L(2,w)) = FP.(structname).COP.Both(:,CONTACT.(structname).EVENTS_L(1,w):CONTACT.(structname).EVENTS_L(2,w));
                                FP.(structname).FM.Left(:,CONTACT.(structname).EVENTS_L(1,w):CONTACT.(structname).EVENTS_L(2,w)) = FP.(structname).FM.Both(:,CONTACT.(structname).EVENTS_L(1,w):CONTACT.(structname).EVENTS_L(2,w));
                            end
                            
                            for d = 1:size(FRAME.(structname).Anatomical.RightFoot.R, 3)
                                try
                                    MARKERS.(structname).Derived.RightMPJC(:,d) = FRAME.(structname).Anatomical.RightForefoot.O(:,d)  +  FRAME.(structname).Anatomical.RightForefoot.R(:,:,d) * REFMARKERS.Derived.RightMPJCinForefoot;
                                    MARKERS.(structname).Derived.RightAnkleJC(:,d) = FRAME.(structname).Anatomical.RightShank.O(:,d)  +  FRAME.(structname).Anatomical.RightShank.R(:,:,d) * REFMARKERS.Derived.RightAnkleJCinShank;
                                    MARKERS.(structname).Derived.RightKneeJC(:,d) = FRAME.(structname).Anatomical.RightThigh.O(:,d)  +  FRAME.(structname).Anatomical.RightThigh.R(:,:,d) * REFMARKERS.Derived.RightKneeJCinThigh;
                                    MARKERS.(structname).Derived.RightHipJC(:,d) = FRAME.(structname).Anatomical.RightPelvis.O(:,d)  +  FRAME.(structname).Anatomical.RightPelvis.R(:,:,d) * REFMARKERS.Derived.RightHipJCinPelvis;
                                end
                                try
                                    MARKERS.(structname).Derived.LeftMPJC(:,d) = FRAME.(structname).Anatomical.LeftForefoot.O(:,d)  +  FRAME.(structname).Anatomical.LeftForefoot.R(:,:,d) * REFMARKERS.Derived.LeftMPJCinForefoot;
                                    MARKERS.(structname).Derived.LeftAnkleJC(:,d) = FRAME.(structname).Anatomical.LeftShank.O(:,d)  +  FRAME.(structname).Anatomical.LeftShank.R(:,:,d) * REFMARKERS.Derived.LeftAnkleJCinShank;
                                    MARKERS.(structname).Derived.LeftKneeJC(:,d) = FRAME.(structname).Anatomical.LeftThigh.O(:,d)  +  FRAME.(structname).Anatomical.LeftThigh.R(:,:,d) * REFMARKERS.Derived.LeftKneeJCinThigh;
                                    MARKERS.(structname).Derived.LeftHipJC(:,d) = FRAME.(structname).Anatomical.LeftPelvis.O(:,d)  +  FRAME.(structname).Anatomical.LeftPelvis.R(:,:,d) * REFMARKERS.Derived.LeftHipJCinPelvis;
                                end
                            end
                            
                            KINETICS.(structname) = InverseDynamik_Hof(FRAME.(structname).Anatomical, OPTIONS, FP.(structname), MARKERS.(structname));
                            
              