import Foundation
import Domains

extension URL {
    enum Deny: String {
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
        serving_sys = "serving-sys"
        
        static func validation(domain: Domain) -> Policy.Validation? {
            Self(rawValue: domain.name)
                .map {
                    .block(tracker: $0.rawValue)
                }
        }
    }
}
