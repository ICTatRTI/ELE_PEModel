$title Data for Electricity Market Analysis model (EMA)


$onInLine

* data
parameters
        capacity(r,u,v)         capacity of existing /* MEEDE */
        heatrate(r,u,v)         heat rate of existing units /* MEEDE */
        size(r,u,v)             size of existing units /* Not used */
        count(r,u)              number of existing units /* MEEDE but not used */
        emis_factor(r,u,p)      pollutant emissions factors (CO2 SO2 NOx Hg) /* constant by fuel type--unmodified */

        capcost(r,u,v)          capital costs ($ per kW) /* only used in capacity added--unmodified */
        fomcost(r,u)            fixed O&M ($ per kW) /* MEEDE */
        vomcost(r,u)            variable O&M ($ per MWh) /* MEEDE */
        pf(r,f,t)               fuel prices /* MEEDE for oil, gas, coal; unmodified for bio, nuc */
        fueltype(u,f)           type of fuel used by a unit /* unmodified */

        pele(r,t)               electricity price ($ per MWh) /* used to calculate elasticity--unmodified*/
        dele(r,t)               annual demand (TWh) /* NEEDE (= netgen) */
        loadpct(r,l)            percentage of demand by load segment /* unmodified */
        dadj(r,t)               demand adjustment to turn demand into NEL (including CHP and trade) /* unmodified */
        hours(r,l)              hours per load segment /* constant */
        maxCF(r,u,l)            maximum capacity factor /* unmodified */
        peak(r,t)               peak demand /* unmodified */
        RsrvMargin(r)           reserve margin /* unmodified */
        rsrv_factor(r,u)        reserve margin contribution factor for wind-solar /* unmodified */

        transmit_limit(r,rr)    transmission limits /* unmodified */
*       wind_limit              maximum wind capacity by wind class and cost class /* not used */
        geo_limit               maximum geothermal /* unmodified */
        lfg_limit               maximum landfill gas /* unmodified */

        wind_limit(r,u,cc)      Limits on wind resource (GW) /* unmodified */
        wind_cost_nrel(r,u,cc)  Cost of wind transmission ($ per kW) /* unmodified */

        pbio(r,biostep,t)       price of biomass by step function /* unmodified */
        biosupply(r,biostep,t)  supply of biomass by step function /* unmodified */
        chk_bio /* unmodified */
        chk_wind /* unmodified */
;

* Load in data unmodified from original PE model
$gdxin '..\Data\output\model_data.gdx'
$loaddc maxCF hours transmit_limit RsrvMargin rsrv_factor loadpct fueltype geo_limit lfg_limit emis_factor wind_limit wind_cost_nrel=wind_cost

* Load in New data from MEEDE -------------------
$gdxin '..\Data\output\MEEDE_capacity.gdx'
$loaddc capacity

$gdxin '..\Data\output\MEEDE_count.gdx'
$loaddc count

$gdxin '..\Data\output\MEEDE_fomcost.gdx'
$loaddc fomcost

$gdxin '..\Data\output\MEEDE_vomcost.gdx'
$loaddc vomcost

$gdxin '..\Data\output\MEEDE_heatrate.gdx'
$loaddc heatrate

$gdxin '..\Data\output\MEEDE_size.gdx'
$loaddc size

* Replacing data to remove 2010, 2015 years ----------
$gdxin '..\Data\output\biosupply_2020.gdx'
$loaddc biosupply

$gdxin '..\Data\output\capcost_2020.gdx'
$loaddc capcost

$gdxin '..\Data\output\dadj_2020.gdx'
$loaddc dadj

$gdxin '..\Data\output\dele_2020.gdx'
$loaddc dele

$gdxin '..\Data\output\pbio_2020.gdx'
$loaddc pbio

$gdxin '..\Data\output\peak_2020.gdx'
$loaddc peak

$gdxin '..\Data\output\pele_2020.gdx'
$loaddc pele

$gdxin '..\Data\output\pf_2020.gdx'
$loaddc pf

biosupply(r,biostep,t)  = biosupply(r,biostep,t) * 1e3;

* adjust

* additional parameters
$set rho 0.05
parameter
        ypp(t)                  years per period
        rho                     interest rate per year          /%rho%/
        delta(yr)               depreciation
        pv(yr)                  present value of period t

        fuelcoef(r,u,f)         fuel use coefficient (for biomass cofiring)
        pvom(r,t)               price index for variable O&M
        pfom(r,t)               price index for fixed O&M
        pcap(r,t)               price index for capital costs
*       pfuel(r,f,t)            price index for fuel costs
        emis_cap(p,t)           emissions cap
        cap_limit(*,t)          limit on new capacity

        pelas(r,t)              demand elasticity for electricity
        lnr_coef                Demand coefficient for consumer surplus (linear)
        qdr_coef                Demand coefficient for consumer surplus (quadratic)

        PS_effic                pump storage efficiency
        PS_frac(l)              fraction of morning-evening hours needed to get full day-peak availability

        K_chrg                  capital charge rate (from IPM)
        IDC                     interest during construction (approx from old model)
;

delta(yr)                       = (1/(1+rho))**(yr.val-2020);

loop(yr$(yr.val lt 2050),
pv(yr)  = delta(yr) + delta(yr+1) + delta(yr+2) + delta(yr+3) + delta(yr+4);
);

loop(yr$(yr.val ge 2050),
pv(yr)
        = delta(yr) + delta(yr+1) + delta(yr+2) + delta(yr+3) + delta(yr+4)
        + delta(yr+5) + delta(yr+6) + delta(yr+7) + delta(yr+8) + delta(yr+9)
        + delta(yr+10) + delta(yr+11) + delta(yr+12) + delta(yr+13) + delta(yr+14)
        + delta(yr+15) + delta(yr+16) + delta(yr+17) + delta(yr+18) + delta(yr+19)
        + delta(yr+20) + delta(yr+21) + delta(yr+22) + delta(yr+23) + delta(yr+24);
);

display delta,pv;

fuelcoef(r,u,f)                 = 1;
fuelcoef(r,bio_cf,bio)          = 0.9;

PS_effic                        = 0.8;
PS_frac(mrnevn)
        = sum(num,  sum(daytime, hours(num,daytime)) - sum(night, hours(num,night))*(1+(1-PS_effic))  )
                / sum(num,  sum(mrnevns,hours(num,mrnevns))*(1+(1-PS_effic)) );
display PS_frac;

K_chrg(u)                       = 0.13;
K_chrg("igcc")                  = 0.13;
IDC                             = 0.2;


parameter
        CarbTax         carbon tax amount ($ per MTCO2)
        CarbSeq         carbon sequestration costs ($ per MTCO2);

carbtax("2020")                 = 0;

carbseq(t)                      = 0;


* use shares from demands in ELEC model to share out CGE demands
parameter
        dele_shr;

dele_shr(r_cge,r,t)$mapRegions(r_cge,r) = dele(r,t) / sum(mapRegions(r_cge,rr), dele(rr,t));

* index on costs (from CGE) - if in loop mode

$if set iter $goto loadCGE

pvom(r,t)                       = 1;
pfom(r,t)                       = 1;
pcap(r,t)                       = 1;

$goto setdemands

$label loadCGE

$evalglobal piter %iter% - 1
$include load_CGE


$label setdemands

* adjust peak
peak(r,t)                       = peak(r,"2020") * dele(r,t) / dele(r,"2020");
display peak;

* misc *
ypp(t)$(t.val lt 2050)          = 5;
ypp(t)$(t.val ge 2050)          = 25;

emis_cap(p,t)                   = +inf;
cap_limit("nuc_N",t)            = +inf;

newv(v)$(ord(v) ne 1)           = yes;
vt("2020",t)                    = yes;
vt(v,t)$(ord(t) ge ord(v))      = yes;
tv(v,t)$sameas(v,t)             = yes;

feasible(r,u,"2020",t)$capacity(r,u,"2020")     = yes;
feasible(r,newu,newv,t)$vt(newv,t)              = yes;


* approx of transmission/distribution costs for retail price reporting
parameter
        distrib(t);

distrib("2020") = 36.1;


**------------- checks -----------------**

parameter
        chk_existing
        chk_new;

chk_existing(r,u,"fom")$(capacity(r,u,"2020") and not fomcost(r,u))     = 1;
chk_existing(r,u,"vom")$(capacity(r,u,"2020") and not vomcost(r,u))     = 1;
chk_existing(r,u,"heatrate")$(capacity(r,u,"2020") and not heatrate(r,u,"2020"))        = 1;
chk_existing(r,u,l)$(capacity(r,u,"2020") and not maxCF(r,u,l)) = 1;
chk_existing(r,u,"rsrv_factor")$(capacity(r,u,"2020") and not rsrv_factor(r,u)) = 1;
chk_existing(r,u,p)$(capacity(r,u,"2020") and not emis_factor(r,u,p))   = 1;

chk_existing(r,u,p)$noCO2exist(u)                       = 0;
chk_existing(r,u,p)$(not CO2(p))                        = 0;
chk_existing(r,"ps_x","rsrv_factor")                    = 0;

chk_new(t,r,newu,"fom")$(not fomcost(r,newu))           = 1;
chk_new(t,r,newu,"vom")$(not vomcost(r,newu))           = 1;
chk_new(t,r,newu,"cap")$(not capcost(r,newu,t))         = 1;
chk_new(t,r,newu,"heatrate")$(not heatrate(r,newu,t))   = 1;
chk_new(t,r,newu,l)$(not maxCF(r,newu,l))               = 1;
chk_new(t,r,newu,"rsrv_factor")$(not rsrv_factor(r,newu) and not wndn(newu))= 1;
chk_new(t,r,newu,p)$(not emis_factor(r,newu,p))         = 1;

chk_new(t,r,geo,"cap")$(not geo_limit(r,geo))           = 0;
chk_new(t,r,wnd,"fom")$(not sum(cc,wind_limit(r,wnd,cc)))               = 0;
chk_new(t,r,geo,"fom")$(not geo_limit(r,geo))           = 0;
chk_new(t,r,lfg,"fom")$(not lfg_limit(r,lfg))           = 0;
chk_new(t,r,wnd,"vom")                                  = 0;
chk_new(t,r,slr,"vom")                                  = 0;
chk_new(t,r,geo,"vom")                                  = 0;
chk_new(t,r,lfg,"vom")$(not lfg_limit(r,lfg))           = 0;

chk_new(t,r,noCO2new,"CO2")                             = 0;
chk_new(t,r,u,p)$(not CO2(p))                           = 0;

chk_new(t,r,"slrPV_N",night)                            = 0;

chk_new(t,r,wnd,l)$(not sum(cc,wind_limit(r,wnd,cc)))           = 0;
chk_new(t,r,wnd,"rsrv_factor")$(not sum(cc,wind_limit(r,wnd,cc)))       = 0;

* don't check slr CSP for some regions
chk_new(t,r,"slrCSP_N",l)                               = 0;
chk_new(t,r,"slrCSP_N","rsrv_factor")                   = 0;

option chk_existing:2:2:1;
option chk_new:2:3:1;
display chk_existing,chk_new;

display pf;

display vt,tv,feasible,newv,newu;


parameter lvlcost,lcoe;

lvlcost(r,existu,"fuel")$capacity(r,existu,"2020")
        = sum(f,pf(r,f,"2020") * fueltype(existu,f) * heatrate(r,existu,"2020") * 1e-3 );

*
lvlcost("USA",existu,"fuel")
        = sum(r, capacity(r,existu,"2020") * sum(l, hours(r,l) * maxCF(r,existu,l)) * sum(f,pf(r,f,"2020") * fueltype(existu,f) * heatrate(r,existu,"2020") * 1e-3 ) )
                / sum(r, capacity(r,existu,"2020") * sum(l, hours(r,l) * maxCF(r,existu,l)) );


lvlcost(r,existu,"fom")$sum(l, (capacity(r,existu,"2020") * hours(r,l) * maxCF(r,existu,l) * 1e-3) )
        = capacity(r,existu,"2020") * fomcost(r,existu)
                / sum(l, (capacity(r,existu,"2020") * hours(r,l) * maxCF(r,existu,l) * 1e-3) );

*
lvlcost("USA",existu,"fom")
        = sum(r, capacity(r,existu,"2020") * fomcost(r,existu))
                / sum((r,l), (capacity(r,existu,"2020") * hours(r,l) * maxCF(r,existu,l) * 1e-3) );

lvlcost(r,existu,"vom")$capacity(r,existu,"2020")
        = vomcost(r,existu);

*
lvlcost("USA",existu,"vom")
        = sum(r, capacity(r,existu,"2020") * sum(l, hours(r,l) * maxCF(r,existu,l)) * vomcost(r,existu))
                / sum(r, capacity(r,existu,"2020") * sum(l, hours(r,l) * maxCF(r,existu,l)) );

lvlcost(r,existu,"total")       = lvlcost(r,existu,"fuel") + lvlcost(r,existu,"fom") + lvlcost(r,existu,"vom");
lvlcost("USA",existu,"total")   = lvlcost("USA",existu,"fuel") + lvlcost("USA",existu,"fom") + lvlcost("USA",existu,"vom");


option lvlcost:1:2:1;
display lvlcost;


lcoe(existu,r)$capacity(r,existu,"2020")        = lvlcost(r,existu,"total");
*lcoe(newu,r)$maxCF(r,newu,"sum_day")            = lvlcost_new(r,newu,"total","2030");

option lcoe:1;
display lcoe;
