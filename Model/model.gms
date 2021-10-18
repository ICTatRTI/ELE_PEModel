$title Electricity Market Analysis model (EMA)
* Copyright RTI International 1/1/2011

* printing options
$onSymList
$offinclude

$if not set scn $set scn ces
$if not set carbtax $set carbtax 0


**--- Include sets ---**
$include '..\Model\sets.gms'


**--- Include data ---**
$include '..\Model\data.gms'

parameter
        deflator;

deflator        = 1 / 1.105783;


parameter
        RESlvl          level of RES
        RESswtch        switch on RES policy
        CESlvl          level of CES
        CESswtch        switch on CES policy
        minGENlvl       minimum generation levels;


RESswtch(t)             = no;
CESswtch(t)             = no;

RESlvl("2020")          = 0.0;

CESlvl("2020")          = 0.0;

parameter chk_carb_prc;

**--- Variables for Model ---**
positive variables
        DemandSeg(r,t)          Electricity demand by load segment
        GEN(r,u,v,l,t)          Generation by units
        CAP(r,u,v,t)            Capacity of units
        INV(r,u,v,t)            Investment in new capacity
        Retire(r,u,v,t)         Retirement of capacity
        Fuel(r,f,t)             Fuel use
        Biomass(r,biostep,t)    Biomass fuel use
        Transmit(r,rr,l,t)      Transmission
        Emis(r,p,t)             Emissions
        Emis_Saved(p,t)         Emission allowances saved
        Emis_Withdrawn(p,t)     Emission allowances withdrawn
        Emis_Bank(p,t)          Emissions bank
        rm_wind(r,rm_step,u,t)
        rm_slr(r,rm_step,u,t)
        wind_cap(r,u,cc)        New wind capacity (GW)
;

variables
        obj                     Objective (producer surplus)
        Demand(r,t)             Total annual demand index by region;

* Model equations *
equations
        objdef                  Objective function definition
        c_DemandSeg(r,l,t)      Electricity demand by load segment
        c_Demand(r,t)           Total electricity demand
        c_GEN(r,u,v,l,t)        Generation
        c_Fuel(r,f,t)           Fuel use
        c_Biomass(r,t)          Biomass use
        c_Emis(r,p,t)           Emissions
;

**--- Objective Function ---**
objdef..
        obj =e= sum(t, pv(t) * sum(r,

* variable O&M costs (TWh times $/MWh equals $ million)
        + sum((feasible(r,u,v,t),l), GEN(r,u,v,l,t) * pvom(r,t) * vomcost(r,u) )

* fixed O&M costs (GW times $/kW-yr equals $ million)
        + sum(feasible(r,u,v,t), CAP(r,u,v,t) * pfom(r,t) * fomcost(r,u))

* fuel costs - without biomass (TWh times MMBtu/GWh times $/MMBtu divided by 1e+3 equals $ million)
        + sum((feasible(r,u,v,t),l), GEN(r,u,v,l,t) * sum(f$(not bio(f)), pf(r,f,t) * fueltype(u,f) * heatrate(r,u,v)) * 1e-3 )

* biomass costs by supply step
        + sum(biostep, biomass(r,biostep,t) * pbio(r,biostep,t) * 1e-3 )

* wheeling charges (TWh times $/kWh * 1e-3 equals $million)
* (demand in TWh) - 2.9 cents per kWh = $2,900,000 per TWh, 2.9 mills per kWh is $0.0029/kWh
        + sum((rr,l), Transmit(r,rr,l,t) * 0.029 * 1e-3)
))
;


**--- Constraints ---**
* Total annual demand
c_Demand(r,t)..
        Demand(r,t) =e= sum(l, DemandSeg(r,t) * dele(r,t) * loadpct(r,l) * dadj(r,t));

* Demand by load segment
c_DemandSeg(r,l,t)..
          sum(feasible(r,u,v,t), GEN(r,u,v,l,t))
        + sum(rr, Transmit(r,rr,l,t) * (1-0.02))
        - sum(rr, Transmit(rr,r,l,t))
          =g=
        DemandSeg(r,t) * dele(r,t) * loadpct(r,l) * dadj(r,t);

* Generation (GW times hours per load segment)
c_GEN(r,u,v,l,t)$(feasible(r,u,v,t) and hours(r,l) and not ps(u))..
        GEN(r,u,v,l,t) =l= CAP(r,u,v,t) * hours(r,l) * maxCF(r,u,l) * 1e-3
;

** Constraints for calculating output variables
* Fuel use (trillion Btu)
c_Fuel(r,f,t)..
        Fuel(r,f,t) =e= sum((u,v,l), GEN(r,u,v,l,t) * heatrate(r,u,v) * fueltype(u,f)) ;

* Biomass use - aggregated across supply steps (trillion Btu)
c_Biomass(r,t)..
        sum(biostep, biomass(r,biostep,t)) =g= fuel(r,"bio",t);

* CO2 Emissions in MMTC (GWh times MMBtu/GWh times kg/MMBtu divided by 1000 divided by 1 million = million metric tons)
c_Emis(r,p,t)$CO2(p)..
        Emis(r,p,t)
          =e=
        sum((u,v,l), GEN(r,u,v,l,t) * heatrate(r,u,v) * emis_factor(r,u,p)) / 1e+6;

model elec /all/;

** Some bonus constraints!

* upper bound on transmission
transmit.up(r,rr,l,t)                                   = transmit_limit(r,rr) * hours(r,l) * 1e-3;

* set capacities from data
*CAP.up(r,u,"2020",t)                                    = capacity(r,u,"2020");
* I changed this from an upper bound to an equality constraint */
CAP.fx(r,u,"2020",t)                                    = capacity(r,u,"2020");
* anything else must have 0 capacity
CAP.fx(r,u,"2020",t)$(not capacity(r,u,"2020"))         = 0;

* generation = 0 for infeasible combinations
GEN.fx(r,u,v,l,t)$(not feasible(r,u,v,t) and not ps(u)) = 0;
GEN.fx(r,u,"2020",l,t)$(not capacity(r,u,"2020"))       = 0;

GEN.fx(r,u,v,l,t)$(ps(u))                               = 0;

* New constraint to keep the demand multiplier from being suppressed to zero with the absense of the Consumer Surplus constraint
DemandSeg.fx(r,t)                                       = 1;

* upper bound on biomass use to equal supply
biomass.up(r,biostep,t)         = biosupply(r,biostep,t);

* Solve the model
elec.holdfixed  = 1;
elec.iterlim = 250000;
option QCP=CPLEX
solve elec using qcp minimizing obj;

* save results
$include '..\Model\findings.gms'

* save results
$batinclude '..\Model\Output\report.gms' %scn%


execute_unload '..\Model\Output\EMF_ELEC_results_%scn%.gdx',EMF_elec;

execute_unload '..\Model\Output\results_%scn%.gdx', USAphy%scn%,USAdlr%scn%;

parameter
        carb_results;

carb_results(t,"emis")          = sum(r, emis.l(r,"co2",t));
carb_results(t,"carbtax")       = carbtax(t);
carb_results(t,"price")         = ( sum((r,l),(c_demandseg.m(r,l,t) * DemandSeg.l(r,t) * dele(r,t) * loadpct(r,l) * dadj(r,t))) / sum((r,l),(DemandSeg.l(r,t) * dele(r,t) * loadpct(r,l) * dadj(r,t))) ) / pv(t);
carb_results(t,"nuc")           = sum((r,nucu,v,l), gen.l(r,nucu,v,l,t));
carb_results(t,"CCS")           = sum((r,u,v,l)$ccsu(u), GEN.l(r,u,v,l,t));

option carb_results:1;
display carb_results;

* OUTPUTS: TRICK GAMS into outputting data in csv format
File generation_dat /..\Model\Results\EMA_output_generation.csv/,
*        wholesale_dat /.\EMA\Model\Results\EMA_output_wholesale.csv/,
*        wholesale_seg_dat /.\EMA\Model\Results\EMA_output_wholesale_seg.csv/,
*        demand_seg_dat /.\EMA\Model\Results\EMA_output_demandseg.csv/,
*        demand_reg_dat /.\EMA\Model\Results\EMA_output_demandreg.csv/,
        capacity_dat /..\Model\Results\EMA_output_capacity.csv/,
*        transmission_dat /.\EMA\Model\Results\EMA_output_transmission.csv/,
*        emissions_dat /.\EMA\Model\Results\EMA_output_emissions.csv/,
*        retirement_dat /.\EMA\Model\Results\EMA_output_retirement.csv/;
        fomcost_dat /..\Model\Results\EMA_output_fomcost.csv/,
        vomcost_dat /..\Model\Results\EMA_output_vomcost.csv/;


put generation_dat;
put 'region,unit,load_segment,vintage,time,value'/ ;
* loop through region, unit, "vintage", load_segment, year
loop((r,u,v,l,t), put r.tl:0,',':0,u.tl:0,',':0,l.tl:0,',':0,v.tl:0,',':0,t.tl:0,',':0,GEN.l(r,u,v,l,t):0:2 /);

*put wholesale_dat;
*put 'region,time,value'/;
*loop((r,t), put r.tl:0,',':0,t.tl:0,',':0,(c_demand.m(r,t)/pv(t)):0:2 /);

*put wholesale_seg_dat;
*put 'region,load_segment,time,value'/;
*loop((r,l,t), put r.tl:0,',':0,l.tl:0,',':0,t.tl:0,',':0,(c_demandseg.m(r,l,t)/pv(t)):0:2 /);

* put demand_seg_dat;
* put 'region,time,value'/;
* loop((r,t), put r.tl:0,',':0,t.tl:0,',':0,DemandSeg.l(r,t):0:2 /);

put capacity_dat;
put 'region,unit,vintage,time,value'/;
loop((r,u,v,t), put r.tl:0,',':0,u.tl:0,',':0,v.tl:0,',':0,t.tl:0,',',CAP.l(r,u,v,t):0:2 /);

*put transmission_dat;
*put 'region,destination,load_segment,time'/;
*loop((r,rr,l,t), put r.tl:0,',':0,rr.tl:0,',':0,l.tl:0,',':0,t.tl:0,',':0,Transmit.l(r,rr,l,t):0:2 /);

*put emissions_dat;
*put 'region,pollutant,time,value'/;
*loop((r,p,t), put r.tl:0,',':0,p.tl:0,',':0,t.tl:0,',':0,Emis.l(r,p,t):0:2 /);

*put demand_reg_dat;
*put 'region,time,value'/;
*loop((r,t), put r.tl:0,',':0,t.tl:0,',':0,Demand.l(r,t):0:2 /);

put fomcost_dat;
put 'region,unit,value'/;
loop((r,u), put r.tl:0,',':0,u.tl:0,',':0,fomcost(r,u):0:2 /);

put vomcost_dat;
put 'region,unit,value'/;
loop((r,u), put r.tl:0,',':0,u.tl:0,',':0,vomcost(r,u):0:2 /);

*put retirement_dat;
*put 'region,unit,vintage,time,value'/;
*loop((r,u,v,t), put r.tl:0,',':0,u.tl:0,',':0,v.tl:0,',':0,t.tl:0,',',Retire.l(r,u,v,t):0:2 /);