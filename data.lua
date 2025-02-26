local _, ns = ...

ns.data = {
    defaults = {
        trackAchievements = true,
        characterSpecific = false,
        displayOnLogin = true,
        displayDivision = 3,
        thousandsSeparator = 1,
    },
    divisions = {
        [1] = 1,
        [2] = 5,
        [3] = 10,
        [4] = 25,
        [5] = 50,
        [6] = 100,
        [7] = 250,
        [8] = 500,
        [9] = 1000,
    },
    achievements = {
        [1] = 513,  -- 100
        [2] = 515,  -- 500
        [3] = 516,  -- 1000
        [4] = 512,  -- 5000
        [5] = 509,  -- 10000
        [6] = 239,  -- 25000
        [7] = 869,  -- 50000
        [8] = 870,  -- 100000
        [9] = 5363, -- 250000
    },
    statistic = 588,
    classColors = {
        deathknight = "c41e3a",
        demonhunter = "a330c9",
        druid = "ff7c0a",
        evoker = "33937f",
        hunter = "aad372",
        mage = "3fc7eb",
        monk = "00ff98",
        paladin = "f48cba",
        priest = "ffffff",
        rogue = "fff468",
        shaman = "0070dd",
        warlock = "8788ee",
        warrior = "c69b6d",
    },
}
