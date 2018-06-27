#=
This file implements StatsModels constructors for TableCols.  That is,
it allows one to pass a StatsModels object directly to the TableCol
constructor (or, since the Table constructor falls back to TableCols on
a vararg, the Table constructor).
=#

using StatsBase
using GLM: LinearModel
using StatsModels: DataFrameRegressionModel

varnames(m::LinearModel) = m.pp.X
varnames(m::DataFrameRegressionModel) = coefnames(m.mf)


function Table(header, m::StatisticalModel;
               stats=(:N=>Int∘nobs, "\$R^2\$"=>r2))

    coef_block = Table(header, varnames(m), coef(m), stderror(m))
    stats_pairs = OrderedDict(p.first=>p.second(m) for p in stats)
    stats_block = Table(header, stats_pairs)

    return append_table(coef_block, stats_block)
end
