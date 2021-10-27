$title Data for Electricity Dispatch Partial Equilibrium Model


$onInLine

* data
parameters
        capacity(r,u,v)         capacity of existing /* MEEDE */
        heatrate(r,u,v)         heat rate of existing units /* MEEDE */
        emis_factor(r,u,p)      pollutant emissions factors (CO2 SO2 NOx Hg) /* constant by fuel type--unmodified */

        fomcost(r,u)            fixed O&M ($ per kW) /* MEEDE */
        vomcost(r,u)            variable O&M ($ per MWh) /* MEEDE */
        pf(r,f,t)               fuel prices /* MEEDE for oil, gas, coal; unmodified for bio, nuc */
        fueltype(u,f)           type of fuel used by a unit /* unmodified */

        dele(r,t)               annual demand (TWh) /* NEEDE (= netgen) */
        loadpct(r,l)            percentage of demand by load segment /* unmodified */
        dadj(r,t)               demand adjustment to turn demand into NEL (including CHP and trade) /* unmodified */
        hours(r,l)              hours per load segment /* constant */
        maxCF(r,u,l)            maximum capacity factor /* unmodified */
        peak(r,t)               peak demand /* unmodified */
        rsrv_factor(r,u)        reserve margin contribution factor for wind-solar /* unmodified */
        transmit_limit(r,rr)    transmission limits /* unmodified */

        pbio(r,biostep,t)       price of biomass by step function /* unmodified */
        biosupply(r,biostep,t)  supply of biomass by step function /* unmodified */
;

* Load in New data from MEEDE -------------------
$gdxin '..\Data\output\MEEDE_capacity.gdx'
$loaddc capacity

$gdxin '..\Data\output\MEEDE_fomcost.gdx'
$loaddc fomcost

$gdxin '..\Data\output\MEEDE_vomcost.gdx'
$loaddc vomcost

$gdxin '..\Data\output\MEEDE_heatrate.gdx'
$loaddc heatrate

$gdxin '..\Data\output\MEEDE_dele.gdx'
$loaddc dele

$gdxin '..\Data\output\MEEDE_pf.gdx'
$loaddc pf

* Load in remaining data unmodified
$gdxin '..\Data\output\biosupply_2020.gdx'
$loaddc biosupply

$gdxin '..\Data\output\dadj_2020.gdx'
$loaddc dadj

$gdxin '..\Data\output\pbio_2020.gdx'
$loaddc pbio

$gdxin '..\Data\output\peak_2020.gdx'
$loaddc peak

$gdxin '..\Data\output\model_data.gdx'
$loaddc maxCF hours transmit_limit rsrv_factor loadpct fueltype emis_factor

biosupply(r,biostep,t)  = biosupply(r,biostep,t) * 1e3; /* scaling constant */

* misc *
feasible(r,u,"2020",t)$capacity(r,u,"2020")     = yes;

