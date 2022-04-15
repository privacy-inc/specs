import Foundation
import Domains

extension URL {
    enum Deny: String, Responser {
        case
        pubmatic,
        dianomi,
        hotjar,
        media,
        adalliance,
        yieldlab,
        emsservice,
        flashtalking,
        criteo,
        adition,
        openx,
        indexww,
        googleadservices,
        addthis,
        sparwelt,
        adrtx,
        dwcdn,
        rubiconproject,
        creativecdn,
        medtargetsystem,
        ufpcdn,
        onclickgenius,
        appsflyer,
        onmarshtompor,
        rakamu,
        bongacams,
        bngpt,
        adsco,
        bet365,
        caradstag,
        monkposseacre,
        fgfgnbmeieorr910,
        dexpredict,
        hornsgrid,
        zap,
        apostropheemailcompetence,
        googlesyndication,
        doubleclick,
        adnxs,
        tinypass,
        lijit,
        piano,
        moatads,
        redditmedia,
        crwdcntrl,
        casalemedia,
        demdex,
        googletagservices,
        optimizely,
        cedexis,
        scorecardresearch,
        bounceexchange,
        zeusadx,
        adxnexus,
        revrtb,
        acertb,
        popmonetizer,
        tiodmw,
        ratappe,
        riverhit,
        ahojer,
        impactserving,
        f853150605ccb,
        reactivebetting,
        edigitalsurvey,
        concert,
        voxmedia,
        imrworldwide,
        getpublica,
        taboola,
        ampproject,
        bluekai,
        httpbin,
        wix,
        mathtag,
        outbrain,
        conative,
        adsrvr,
        teads,
        privacymanager,
        consensu,
        adswizz,
        buzzfeed,
        vidible,
        adtelligent,
        jsapicdn,
        advertising,
        spotxchange,
        sitescout,
        technoratimedia,
        aniview,
        loopme,
        getadcdn,
        nodcdn,
        medocdn,
        annocdn,
        safeservingcdn,
        jcontentcdn,
        deliveryapis,
        midserved,
        adxpremium,
        adservd,
        appdynamics,
        newscgp,
        ncaudienceexchange,
        realtor,
        barrons,
        mansionglobal,
        marketwatch,
        nypost,
        decider,
        pagesix,
        knewz,
        penews,
        cxense,
        tapad,
        guim,
        smilewanted,
        smartadserver,
        zemanta,
        adotmob,
        contextweb,
        connectad,
        brealtime,
        bidswitch,
        adform,
        dotomi,
        sascdn,
        doubleverify,
        justpremium,
        kargo,
        g2afse,
        marketland,
        manageintenselyprecisethefile,
        thaudray,
        mediago,
        ad4m,
        sportradarserving,
        bannerflow,
        adcell,
        mcdart,
        awin1,
        intelliad,
        betrad,
        recaptcha,
        liadm,
        makespram,
        fastdnr,
        tipico,
        gaietyastonished,
        subtlepeel,
        glersakr,
        interwetten,
        hetaruvg,
        usercentrics,
        redintelligence,
        yieldmo,
        faphouse,
        seppsmedia,
        big7,
        pornmd,
        rtbbnr,
        zog,
        chaturbate,
        bqnqrr53,
        realsrv,
        mrtbbnr,
        tsyndicate,
        bestcontentfood,
        nnteens,
        sexad,
        strpjmp,
        cams,
        richaudience,
        doublepimp,
        crjpingate,
        livejasmin,
        exosrv,
        adtng,
        retargetly,
        dailymotion,
        adstune,
        blueistheneworanges,
        signifyd,
        cookiebot,
        trustarc,
        tremorhub,
        sharethrough,
        bfmio,
        gumgum,
        everesttech,
        emxdgt,
        socdm,
        servebom,
        slgnt,
        narrativ,
        hubspot,
        lemonswan,
        ebaystatic,
        nmrodam,
        homeday,
        sensic,
        wemass,
        communicationads,
        o2online,
        podigee,
        revjet,
        mediavine,
        yourselpercale,
        adright,
        clckreceiver,
        srvtrck,
        affphnx,
        sparer,
        coolwaytheupgradefree,
        euark,
        spten,
        peech2eecha,
        akamaihd,
        junmediadirect,
        planningunavoidablenull,
        guardianinvadecrept,
        plarimoplus,
        sosigninggrudge,
        eacdn,
        lotteryhibernateauthorized,
        platincasino,
        saunasupposedly,
        visiblejoseph,
        midgetincidentally,
        dissolveddittoteaspoon,
        sentimenthypocrisy,
        thawbootsamplitude,
        tellmadeirafireplace,
        unforgivablegrowl,
        qualitydestructionhouse,
        furstraitsbrowse,
        maltunfaithfulpredominant,
        cedexis_radar = "cedexis-radar",
        user_shield = "user-shield",
        google_analytics = "google-analytics",
        amazon_adsystem = "amazon-adsystem",
        the_ozone_project = "the-ozone-project",
        visitor_analytics = "visitor-analytics",
        adup_tech = "adup-tech",
        bam_x = "bam-x",
        _2mdn = "2mdn",
        _3lift = "3lift",
        _1rx = "1rx",
        onetag_sys = "onetag-sys",
        _360yield = "360yield",
        serving_sys = "serving-sys",
        ad_score = "ad-score",
        ad_srv = "ad-srv",
        jeans_direct = "jeans-direct",
        ssl_images_amazon = "ssl-images-amazon",
        illuma_tech = "illuma-tech",
        boot_upfree_bestheavilyfile = "boot-upfree-bestheavilyfile",
        doubleclick_analytics = "doubleclick-analytics",
        pix_cdn = "pix-cdn",
        saturn_j1407b = "saturn-j1407b",
        hip_97166b = "hip-97166b",
        truste_svc = "truste-svc",
        hs_edge = "hs-edge",
        podigee_cdn = "podigee-cdn",
        media_amazon = "media-amazon",
        antio_nar = "antio-nar",
        destore_daindmade = "destore-daindmade",
        deebcards_themier = "deebcards-themier"
        
        static func response(for domain: Domain, on: URL) -> Policy.Response? {
            Self(rawValue: domain.name)
                .map {
                    .block($0.rawValue)
                }
        }
    }
}
