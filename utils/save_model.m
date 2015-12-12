function [] = save_model(file_name, model, ap, c, cvmodel, cvid, vscore)

res.model   = model;
res.ap      = ap;
res.c       = c;
res.cvmodel = cvmodel;
res.cvid    = cvid;
res.vscore  = vscore;
save(file_name, 'res');

end