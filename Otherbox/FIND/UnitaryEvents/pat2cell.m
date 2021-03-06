function u=pat2cell(u,r,c,b)
% u=pat2cell(u,r,c,b): create (trialid,time) representation of (0,1)-mats 
% ***************************************************************
% *                                                             *
% * Usage:   input:                                             *
% *            structures: u (either UE.Results or Raw.Results or uw ) *
% *                            u.Results.PatI                   *
% *                            u.Results.PatJ                   *
% *                            u.Results.PatK                   *
% *                        r : Raw.Results.ExistingPatterns     *
% *                        c : c.Results.NumberOfNeurons        *
% *                        b : b.Results.Basis                  *
% *                                                             *
% *         Output:                                             *
% *           u.Results.Data: cell array of (trialids,time) per *
% *                           neuron                            *
% *                                                             *
% * See Also:                                                   *
% *          UE(), UEMWA()                                      *
% * Uses:                                                       *
% *                                                             *
% * Future:                                                     *
% *          - loops eliminated - really?                       *
% *                                                             *
% * History:                                                    *
% *         (6) more general version, does NO globals anymore   *
% *             but works on structures                         *
% *            SG, 30.9.98-5.10.98, FfM                         *
% *         (5) version 5 matrix operations                     *
% *            MD, 4.5.97, Freiburg                             *
% *         (4) ijk-interface introduced, don't need            *
% *             RawMat, UEMat, UEMWA_Mat here anymore           *
% *            MD, 2.4.1997, Freiburg                           *
% *         (3) commented                                       *
% *            MD, 3.3.1997, Freiburg                           *
% *         (2) old version worked only for patterns of         *
% *             complexity 2                                    *
% *            MD, 4.3.1997, Freiburg                           *
% *         (1) made faster                                     *
% *            SG, 25.8.1996                                    *
% *         (0) first version                                   *
% *            SG, 12.3.1996                                    * 
% *                                                             *
% *                                                             *
% *                          diesmann@biologie.uni-freiburg.de  *
% *                          gruen@mpih-frankfurt.mpg.de        *
% *                                                             *
% ***************************************************************
% *  Examples:
% *
% * in UE.m:
% *    u=pat2cell(u,r,c,b);
% *    r=pat2cell(r,r,c,b);
% * in UEMWA.m:
% *    uw=pat2cell(uw,r,c,b)
% *
% ***************************************************************
u.Results.Data = cell(c.Results.NumberOfNeurons,1);

if ~isempty(u.Results.PatI)
 % all 0-1 patterns
 bb=inv_hash(r.Results.ExistingPatterns(u.Results.PatI),...
             c.Results.NumberOfNeurons,b.Results.Basis);
	 
 for ni=1:c.Results.NumberOfNeurons
  % in which pattern is neuron ni involved
  i=find(bb(:,ni));
   u.Results.Data{ni}=cat(2,u.Results.PatK(i),u.Results.PatJ(i));
 end
end




