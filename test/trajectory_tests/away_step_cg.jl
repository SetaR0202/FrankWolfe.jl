using FrankWolfe
using Test

using LinearAlgebra

const xp = [
    0.2221194121408555,
    0.37070712502470504,
    0.024120713402762894,
    0.23878317833696794,
    0.9774658250856014,
    0.9328848703961752,
    0.19666437903254597,
    0.3108438697934143,
    0.8611370560284857,
    0.5638902027565588,
    0.6717542256037482,
    0.37500671876420233,
    0.43229958494828336,
    0.4455524748732561,
    0.23223904983081323,
    0.8786466197670292,
    0.5909835272840192,
    0.972946051414218,
    0.8295833654216703,
    0.12165838006949647,
    0.5573162248498043,
    0.7783217768142197,
    0.9405585096577254,
    0.4096010036741623,
    0.4146694259495587,
    0.12202417615334182,
    0.12416203446866858,
    0.3135396651797776,
    0.8463925650597949,
    0.5435139172669606,
    0.05977604793386093,
    0.9179329261313978,
    0.9584333638309193,
    0.288632342896219,
    0.8445244137513961,
    0.7174538816882624,
    0.20921745715914342,
    0.8558382048640315,
    0.32234336062015523,
    0.32349875021987073,
    0.38283519134249555,
    0.33281059318207173,
    0.9068883983548414,
    0.08810942376469555,
    0.4540478820261079,
    0.8286156745759701,
    0.3251714302397716,
    0.6926837792258961,
    0.16918531873053577,
    0.3045901922130101,
    0.6854793931009404,
    0.06651125212604247,
    0.11380352462639065,
    0.08508026574096728,
    0.9547766463258776,
    0.1861768772348652,
    0.5484894320605861,
    0.24822097257281062,
    0.3889425215408887,
    0.49747336643471984,
    0.026478564673962035,
    0.2754275925598161,
    0.5969678463343207,
    0.8896103799119639,
    0.1108714508332197,
    0.9283688295031338,
    0.9713472351114413,
    0.891466118006637,
    0.96634040453533,
    0.00355941854573949,
    0.7867279585604435,
    0.9510563391713888,
    0.0692488661882199,
    0.49865755273497236,
    0.11863122104246815,
    0.1710296777218261,
    0.6363240295890795,
    0.13113427653058585,
    0.09117615810736701,
    0.43340842523155443,
    0.685958886328903,
    0.12577668795016073,
    0.26730497196368863,
    0.9249813878356242,
    0.20938064379327703,
    0.84121853886278,
    0.19283763945286048,
    0.8795998946120226,
    0.9245987481505632,
    0.41859788484460025,
    0.6468433655631147,
    0.2614312743910776,
    0.9109750609820051,
    0.38773597147345606,
    0.17899781432954076,
    0.3444279212619652,
    0.3161112859016656,
    0.9212820835055795,
    0.7501699548719438,
    0.6951058583384379,
]

@testset "Away-Step CG" begin
    # n = Int(1e1)
    n = Int(1e2)
    k = Int(1e4)

    f(x) = norm(x - xp)^2
    function grad!(storage, x)
        @. storage = 2 * (x - xp)
    end

    lmo = FrankWolfe.KSparseLMO(40, 1.0)

    x0 = FrankWolfe.compute_extreme_point(lmo, zeros(n))

    x_true = [
        0.12350331520527039,
        0.2720911600489062,
        0.0,
        0.140167169125791,
        0.8788497081329242,
        0.8342685990885751,
        0.09804837088605657,
        0.212227647433356,
        0.7625208605543947,
        0.46527409557434884,
        0.5731382333696704,
        0.2763905827604689,
        0.3336837864396474,
        0.3469363114955107,
        0.1336290781022528,
        0.780030185474837,
        0.49236737077583526,
        0.8743244783341335,
        0.730967269701777,
        0.02304965724670187,
        0.45870005788163015,
        0.6797054213208934,
        0.8419422209838555,
        0.3109848428453597,
        0.3160534364494893,
        0.023408368324288265,
        0.02554590234308165,
        0.214923591871615,
        0.7477761809848499,
        0.44489775388921676,
        0.0,
        0.8193163927062596,
        0.859817175743167,
        0.19001619361014938,
        0.7459080255491606,
        0.6188376723372043,
        0.11060131843677788,
        0.7572219825793343,
        0.22372714201350155,
        0.2248826346064741,
        0.2842189977123998,
        0.234194441570774,
        0.8082719384545783,
        0.0,
        0.35543171903388127,
        0.7299992900251845,
        0.22655532373895734,
        0.5940675939547932,
        0.07056937013046714,
        0.20597419863272642,
        0.586863240643373,
        0.0,
        0.015194189630647736,
        0.0,
        0.8561604566330895,
        0.08756099706437867,
        0.44987303972084425,
        0.1496049653804154,
        0.2903263916627384,
        0.39885743548767694,
        0.0,
        0.17681118234902266,
        0.49835126912686845,
        0.7909941352550856,
        0.012262316522948954,
        0.829752604845485,
        0.8727309453679273,
        0.7928498840116429,
        0.8677240510599421,
        0.0,
        0.6881116971780795,
        0.8524400345642169,
        0.0,
        0.4000416430046448,
        0.02001508476237797,
        0.07241364329590354,
        0.5377080641185094,
        0.03252490896928947,
        0.0,
        0.334792268924615,
        0.5873428846300117,
        0.02716712761647248,
        0.16868859862650792,
        0.8263648962248804,
        0.11076441441975882,
        0.7426025346638739,
        0.09422137265867661,
        0.7809836031959027,
        0.8259825071643098,
        0.31998162124628227,
        0.5482270985450096,
        0.16281512986932242,
        0.8123588544851766,
        0.28911985191570744,
        0.08038187268675007,
        0.24581172390971173,
        0.2174952886170703,
        0.8226657834983702,
        0.6515537033215051,
        0.5964896156444087,
    ]

    primal_true = 0.9223845604218518
    niters = 1909

    res1 = FrankWolfe.away_frank_wolfe(
        f,
        grad!,
        lmo,
        x0,
        max_iteration=k,
        line_search=FrankWolfe.Adaptive(L_est=100.0),
        print_iter=k / 10,
        epsilon=1e-5,
        memory_mode=FrankWolfe.InplaceEmphasis(),
        verbose=false,
        away_steps=true,
        trajectory=true,
    )

    @test norm(res1[1] - x_true) ≈ 0 atol = 1e-5
    @test res1[3] ≈ primal_true
    @test res1[5][end][1] <= niters

    x_true2 = [
        0.12350325628679909,
        0.27209922793666613,
        0.0,
        0.1401669208593975,
        0.8788494948178499,
        0.8342685623927103,
        0.09804796463636488,
        0.2122275998207822,
        0.7625208834020012,
        0.4652738908441709,
        0.5731379884683532,
        0.27639045997386924,
        0.3336832995487319,
        0.3469361951837413,
        0.1336229980083404,
        0.780030397630848,
        0.49236727599406177,
        0.874329744225315,
        0.7309671468077595,
        0.023042160241989237,
        0.45869985746647546,
        0.679705467413878,
        0.8419422095529443,
        0.31098474678315424,
        0.3160531049488661,
        0.023415892579793818,
        0.025545746462217238,
        0.21492339006780664,
        0.7477763707338895,
        0.4448976738194912,
        0.0,
        0.8193165394183596,
        0.859817070627424,
        0.19001602422893987,
        0.7459081193869738,
        0.6188376817399694,
        0.1106012104488174,
        0.7572218842338574,
        0.22372704506073327,
        0.2248824342409964,
        0.28421873176658263,
        0.2341947720818703,
        0.8082721381894483,
        0.0,
        0.3554316828149227,
        0.7299995942545656,
        0.22655537502111792,
        0.5940675416770479,
        0.07056917339550282,
        0.205973823076617,
        0.5868631102448789,
        0.0,
        0.015195600977709636,
        0.0,
        0.8561603595443996,
        0.08756893289369261,
        0.44987314906166886,
        0.14960475522281372,
        0.2903262193913907,
        0.39885700591829637,
        0.0,
        0.1768112686682394,
        0.4983518341496353,
        0.7909940162586777,
        0.012255265619101422,
        0.8297525700627989,
        0.8727310624708051,
        0.7928498862034395,
        0.8677241994701683,
        0.0,
        0.6881116863638452,
        0.8524400418873481,
        0.0,
        0.40004132924861774,
        0.020014967561619194,
        0.07241355411852693,
        0.5377079346778642,
        0.03251798352195498,
        0.0,
        0.3347921887674731,
        0.5873426243318487,
        0.027168981303859988,
        0.16868876068051325,
        0.8263651638803798,
        0.11076450575931521,
        0.7426024306918094,
        0.09422153728454051,
        0.7809837470618066,
        0.8259826763067796,
        0.31998160902571865,
        0.5482271318602744,
        0.16281519396942526,
        0.8123588180758603,
        0.28911953790429545,
        0.0803816656438147,
        0.24581174746305717,
        0.21749506130863475,
        0.8226657631621945,
        0.6515536470906864,
        0.596489706318256,
    ]

    primal_true2 = 0.9223845604496933
    niters2 = 3408

    res2 = FrankWolfe.away_frank_wolfe(
        f,
        grad!,
        lmo,
        x0,
        max_iteration=k,
        line_search=FrankWolfe.Adaptive(L_est=100.0, eta=0.95, verbose=false),
        print_iter=k / 10,
        epsilon=1e-5,
        momentum=0.9,
        memory_mode=FrankWolfe.OutplaceEmphasis(),
        verbose=false,
        away_steps=true,
        trajectory=true,
    )

    @test res2[3] ≈ primal_true2 atol = 1e-6

    x_true3 = [
        0.12350364160905855,
        0.2720912507358009,
        0.0,
        0.14016737894919556,
        0.8788498863896176,
        0.83426901624493,
        0.09804858376590986,
        0.21222819898266776,
        0.7625211675983882,
        0.46527425004082035,
        0.573138394455831,
        0.27639086842991223,
        0.3336836492542,
        0.3469367015262871,
        0.1336233437062462,
        0.7800306483527641,
        0.4923676450024285,
        0.8743301048502704,
        0.7309673888704789,
        0.02304260429126816,
        0.45870028337813995,
        0.6797058236678196,
        0.8419424107695108,
        0.31098512227015357,
        0.3160535988475176,
        0.023408358109346508,
        0.025546351416447947,
        0.214923870144732,
        0.7477764202045378,
        0.4448980496190519,
        0.0,
        0.8193168093268758,
        0.8598171865270792,
        0.19001650514605778,
        0.7459084135022188,
        0.6188379006111643,
        0.11060177634453179,
        0.7572222388624699,
        0.22372744881962495,
        0.22488297766113136,
        0.2842196974407023,
        0.23419493747178544,
        0.8082723871719079,
        0.0,
        0.3554320385006412,
        0.7299997464397213,
        0.22655567318872008,
        0.5940678549930419,
        0.07056943610960685,
        0.2059743993650674,
        0.5868635475401429,
        0.0,
        0.0151919890089084,
        0.0,
        0.8561606585006025,
        0.08756108714417242,
        0.44987351232451545,
        0.1496053567903214,
        0.2903267440991662,
        0.398857499658823,
        0.0,
        0.1768118504458742,
        0.49835202963825764,
        0.790994367452785,
        0.012256124565600572,
        0.8297528912334032,
        0.8727309391686804,
        0.7928501038401042,
        0.8677244512292245,
        0.0,
        0.6881120640228882,
        0.8524402440686749,
        0.0,
        0.4000417000030933,
        0.0200154362247207,
        0.07241395223591116,
        0.5377083244045926,
        0.03251891157220403,
        0.0,
        0.3347925120063812,
        0.5873426183530177,
        0.0271611272960249,
        0.1686892300620705,
        0.8263653847605529,
        0.11076483683657806,
        0.7426026880906017,
        0.09422332107845836,
        0.7809839803090287,
        0.825982839429656,
        0.3199821281896926,
        0.5482274470499936,
        0.16281572051063387,
        0.8123591550715057,
        0.28912016031441284,
        0.08038280259301499,
        0.24581214317616248,
        0.217495515572685,
        0.8226662321278636,
        0.6515539414710015,
        0.5964899915623191,
    ]

    primal_true3 = 0.9223845601906837
    niters3 = 337

    res3 = FrankWolfe.blended_conditional_gradient(
        f,
        grad!,
        lmo,
        x0,
        max_iteration=k,
        line_search=FrankWolfe.Adaptive(L_est=100.0),
        print_iter=k / 10,
        epsilon=1e-5,
        memory_mode=FrankWolfe.InplaceEmphasis(),
        verbose=false,
        away_steps=true,
        trajectory=true,
    )

    @test norm(res3[1] - x_true3) ≈ 0 atol = 1e-5
    @test res3[3] ≈ primal_true3
    @test res3[5][end][1] <= 338

    x_true4 = [
        0.12350364160905855,
        0.2720912507358009,
        0.0,
        0.14016737894919556,
        0.8788498863896176,
        0.83426901624493,
        0.09804858376590986,
        0.21222819898266776,
        0.7625211675983882,
        0.46527425004082035,
        0.573138394455831,
        0.27639086842991223,
        0.3336836492542,
        0.3469367015262871,
        0.1336233437062462,
        0.7800306483527641,
        0.4923676450024285,
        0.8743301048502704,
        0.7309673888704789,
        0.02304260429126816,
        0.45870028337813995,
        0.6797058236678196,
        0.8419424107695108,
        0.31098512227015357,
        0.3160535988475176,
        0.023408358109346508,
        0.025546351416447947,
        0.214923870144732,
        0.7477764202045378,
        0.4448980496190519,
        0.0,
        0.8193168093268758,
        0.8598171865270792,
        0.19001650514605778,
        0.7459084135022188,
        0.6188379006111643,
        0.11060177634453179,
        0.7572222388624699,
        0.22372744881962495,
        0.22488297766113136,
        0.2842196974407023,
        0.23419493747178544,
        0.8082723871719079,
        0.0,
        0.3554320385006412,
        0.7299997464397213,
        0.22655567318872008,
        0.5940678549930419,
        0.07056943610960685,
        0.2059743993650674,
        0.5868635475401429,
        0.0,
        0.0151919890089084,
        0.0,
        0.8561606585006025,
        0.08756108714417242,
        0.44987351232451545,
        0.1496053567903214,
        0.2903267440991662,
        0.398857499658823,
        0.0,
        0.1768118504458742,
        0.49835202963825764,
        0.790994367452785,
        0.012256124565600572,
        0.8297528912334032,
        0.8727309391686804,
        0.7928501038401042,
        0.8677244512292245,
        0.0,
        0.6881120640228882,
        0.8524402440686749,
        0.0,
        0.4000417000030933,
        0.0200154362247207,
        0.07241395223591116,
        0.5377083244045926,
        0.03251891157220403,
        0.0,
        0.3347925120063812,
        0.5873426183530177,
        0.0271611272960249,
        0.1686892300620705,
        0.8263653847605529,
        0.11076483683657806,
        0.7426026880906017,
        0.09422332107845836,
        0.7809839803090287,
        0.825982839429656,
        0.3199821281896926,
        0.5482274470499936,
        0.16281572051063387,
        0.8123591550715057,
        0.28912016031441284,
        0.08038280259301499,
        0.24581214317616248,
        0.217495515572685,
        0.8226662321278636,
        0.6515539414710015,
        0.5964899915623191,
    ]

    primal_true4 = 0.9223845601906837
    niters4 = 337

    res4 = FrankWolfe.blended_conditional_gradient(
        f,
        grad!,
        lmo,
        x0,
        max_iteration=k,
        line_search=FrankWolfe.Adaptive(L_est=100.0),
        print_iter=k / 10,
        epsilon=1e-5,
        momentum=0.9,
        memory_mode=FrankWolfe.OutplaceEmphasis(),
        verbose=false,
        away_steps=true,
        trajectory=true,
    )

    @test norm(res4[1] - x_true4) ≈ 0 atol = 2e-6
    @test res4[3] ≈ primal_true4
    @test res4[5][end][1] <= 338

end
