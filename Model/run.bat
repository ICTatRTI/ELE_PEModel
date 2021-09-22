goto res
:goto ces
:goto carbtax


: Baseline run
call gams model o=list\bau.lst --scn=bau
gdxxrw i=output\results_bau.gdx o=output\Results.xlsx trace=3 par=USAphyBAU rng=baseline-usa!ac2:al63 cdim=1 par=USAdlrBAU rng=baseline-usa!ap2:ay63 cdim=1

:goto end


: RES Policy run
:res
call gams model o=list\res.lst --scn=res
gdxxrw i=output\results_res.gdx o=output\Results.xlsx trace=3 par=USAphyRES rng=res-usa!ac2:al63 cdim=1 par=USAdlrRES rng=res-usa!ap2:ay63 cdim=1

goto end

: CES Policy run
:ces
call gams model o=list\ces.lst --scn=ces
gdxxrw i=output\results_ces.gdx o=output\Results.xlsx trace=3 par=USAphyCES rng=ces-usa!ac2:al63 cdim=1 par=USAdlrCES rng=ces-usa!ap2:ay63 cdim=1

:goto end

: Carbon Tax Policy run
:carbtax
call gams model o=list\carbtax.lst --scn=carbtax --carbtax=20
gdxxrw i=output\results_carbtax.gdx o=output\Results.xlsx trace=3 par=USAphyCarbtax rng=carbtax-usa!ac2:al63 cdim=1 par=USAdlrCarbtax rng=carbtax-usa!ap2:ay63 cdim=1

goto end

:end



