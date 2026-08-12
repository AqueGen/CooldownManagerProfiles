local _, ns = ...

---------------------------------------------------------------------------
-- Preset Profiles (read-only, ship with addon)
---------------------------------------------------------------------------

ns.presets = {}

-- Display order for preset list
ns.presetOrder = { "preset:luxthos" }

---------------------------------------------------------------------------
-- Luxthos CDM Layouts
-- Source: https://www.luxthos.com/cooldown-manager-profiles-world-of-warcraft-midnight/
---------------------------------------------------------------------------

ns.presets["preset:luxthos"] = {
    name = "Luxthos",
    description = "Cooldown Manager layouts by Luxthos for all classes.",
    author = "Luxthos",
    url = "https://www.luxthos.com/",
    -- Bump this timestamp whenever the Luxthos layouts change so auto-sync re-prompts.
    modified = 1786492800, -- 2026-08-12 00:00:00 UTC
    layouts = {
        -----------------------------------------------------------------
        -- DEATH KNIGHT
        -----------------------------------------------------------------
        DEATHKNIGHT = {
            {
                name = "Luxthos - Blood",
                spec = "Blood",
                data = "1|PdA/TFNRFAbwc0+pohVluvE7Dq96WRSJTG5d0M3BhEF8YxNbSmLsYNXIJNZAQuJoFLfGQNLNyYmFdEIJ/oHNFQZaChX/RSfzvb64/L57b96978t5ln3SOFtoZOuvbuH9MnwPcQbxAPwh1nvwe/BdhAJ8G9EnRB8RcghDiDZN9FqMaBvhFPw+oi8IZxBOo/UCO6OIthB9NnHFAxMtrSIsm7iZBwhrzIcIN0001+TmEXnM5zbRmuRmlhfbJq6zSKYw4k305AaP9xFWmF3yjfwgP8kv8pv8NXE7RyZud8HEtZ8TbosdE335jqvv5MhEh6om+nXbJDP4lmX/mGj5KrlPeFbumuh02UQr58htEpvo0q6Jvr5skjkxbJI5/oFs8KmL5BK5QsbJKOHHg2O8ceGNzv+v00k7aWk1LeaKB/mnSStEW+cXkwElM8GIR1hDazKZoutMpcPRXBNhpQm/N1dXdwy+nWY3zcN+hkI/44F+rveSTP44V9esS1okq0a2dr1UrFXyN+7NTFdq+bH8xN1q9c4/",
            },
            {
                name = "Luxthos - Frost",
                spec = "Frost",
                data = "1|VdBLL0NREAfwObfaKh9AZ2JRrLwlmrCyqdgg2ooPYIE2c2miTYiVusJKQkI9ErSxYOkLKAspCWs726baSrwiKInMaSOx+c2c5N45Z/7L9sWUuy/lsHb8aDqQP3C6h8DIjiHnkB/RdCI/IOeRC8hF5GfkEvIn8hNGnjHygvyF173Ib8g/yN+Y9SG/YqZEoPyjwjyB2k2iaaBZRaDCSeFASAmHwj6aQKASXiFNoAJBArV1TKBGcnJ0EaidC2GDQG3XE6hgjdBNoFbW5Z5a6c4I1Oal/Dsk3w0KC8KdTJmTAXbBi6ZUfweB2psU7vHqnUAdzApRAqOpjsCwzgls1acExqpbumECm/NGuJVjs9AidApdQqvQJrQT2FyNR4b1Lw7Pkh6JWV/DWnltvZjeODBXDkkvqDdKeMvv0jHoQHQCifQJ8kPcMpQDOV+phUotVupjuWZKccuwK/2Cv25edylHrH9iPBbyDM6Ep0IxT7tnYDYSjf0C",
            },
            {
                name = "Luxthos - Unholy",
                spec = "Unholy",
                data = "1|TZK/a5NhEMfvLmkbqbVSNPYOSqNbq0UR9y4iVTehtJZQySBJ9L03Q6viIJjGZsig0f5AUJGAk1OH0sF2EZeC/gUObhG0goiTKNV+n7wFl8/d8+OO732f50HX/dbgeCtdezqjPqh+TL1Xoz9GXMyqT6mLbm9ptGsktXvqZMRHiupp9UPqBzX+pp7SSkUr6+p9Rnzjq3rGKJVZU+9RP6zej5KyereR7MTabuL0nBEPX8D970Z85YuRXMsbSb2B5QYOfqDuJhADEfZ+I3NgyYjLm8iWgRVg1YgLv4y4+cmIH7XVs0b8eAjIA8+Aj0b8RIFp4CXw2YiX5vZ6LDMwgeUbZOj7/J0Rv/hrJCO3jeTiHSO5mgYuGUn+rJHM9mOArJEUJoxk8acR971VH1A/aiQzeaNUz3vgA6YfAUaB08AZ4CQwBpwySh048YqrwThZSBpIvZFbSJzNHH8YXAztO/KDcsz6nw7oDeYmI80FWcF69YHXGu1Wa8KsTojd6pLEqU7c3urEdrNaky4OnyJUhOdK9qTe2M924pC10rfOXy/Ml3KX43KxNJ8by03GpUp09x8=",
            },
        },
        -----------------------------------------------------------------
        -- DEMON HUNTER
        -----------------------------------------------------------------
        DEMONHUNTER = {
            {
                name = "Luxthos - Devourer",
                spec = "Havoc",
                data = "1|PdC7SgNREMbxOXuImsJL6Q4E1nRegjbWFm7hSyjCsmUSXROj2LhGiBZaKAvBbkUbLy/gDVLrAyj4AsZLow8g/0XT/PjmMIc5Z3Zz2+noVmqb7Tm3IypmuQFVaLkdo2KKp27Hqjj+K4c1WINVqMMerMA+RCo2X+DmCWUZKiom6JJS0jt8wCd8qZiDG7iFO7iHB3iGF/hWMYeDMATDMALzsAhLsAGbKibhGQll8KbiHCcwq2IHflScowu4hCu4VrH9j/BEyzhMwDTMwCRMQYlfFs8kzvbl7Px/Ouh6cTZgLM7GnmcrjJuO6cs6e6nRS62/ZPOFuOnkTGobfliuVryFeqUWRl7J88P1aj0Ko18=",
            },
            {
                name = "Luxthos - Havoc",
                spec = "Havoc",
                data = "1|Lc89TwJBEAbg2T3xozUhcabxtENA/REU2NjSelFiIAjGnCZo43maGGNtsGCXKwxUxNgAhRZaKtjqD7AzsUGiaNDMQvO8u8nuuzvHocNgpuj5pQSqW1R3WE+haqPOoD5DnUVdRaVR57A8QGVh+Q8VoJKoFlGNYX0aVQfLv6gPCER/lQkIrMku6haBvDhlGlh5IZD9awzCBMJxCcTmGuPwtsjsE4ivDV75BGJgEYjvGIF4zxKIjwiB6D4QiN4Kc84885Ea80Mgm/cEshRl+M3SG4G83CaQrTjqJoH8vCGQvVkCayqElVcCa+KReeLvRpgFZolZZqJMjInzpfkr8LCeEh6qjjwx45gBh+0XDQzCtmdGnzsy/cJxa6i050sxjqo9TJ0ZZXaUuVFWTZpGz5chYTrNynMT6a1C3k7u5t30jh23k85eYf0f",
            },
            {
                name = "Luxthos - Vengeance",
                spec = "Vengeance",
                data = "1|NZFLL0NhEIbnTNGKFSvvrMpCgjkhsbeycNk4C+oSmmoOulAhhHTFaZXEJexsSETj8gf8AFuW+BliIU0khMzX2jzvZCZf5n3nKzXuXLUXomrxfBjBMoIy9AbBNbSMIAedh84hqECz0DS0BH9UKJb4FPK+rw3j0CI0gs5Cp6AL0AnoJHQGmoJOQzNCHOsSYl6E3iIYE+KGDyGmEZs8CrH3ha1nIR4dhB8X8jIp+M3Y2ofeCXm/BWul4b8IceMu/ITpuxDHH+zRmhAf2+z0TYjPWg1tQnz0Y4MBIT5psSpneBXiw6oQP10I8filUCz+ZHi2WN2GHkOfod/Qa1CDLxRr7qxQBC276BzVTOttsvh/GOhex4F5W3Hu3QoXKF4z7qI39N1D53aL7DVB5+uarmu2rqWaBrm6Vpy6xVZ57gtcL6putw+FK6v55PBmfiNcT/rJyTC/FGby2fAP",
            },
        },
        -----------------------------------------------------------------
        -- DRUID
        -----------------------------------------------------------------
        DRUID = {
            {
                name = "Luxthos - Balance",
                spec = "Balance",
                data = "1|NdG5SwNREAbwNy94FaZTZh4q0ULwWPUPUIusjSIWgkFLYxQETUwwvTHpgkdhIXaSSkwrAdvYaCKkTVRQtEjpgQdW8r2Nze+bHd7u7M5mmnZOOZZKH4eNoiW/UbT4yysc4VVeQ+eU81zhIuc4xCdSL/CbkOZ3oQOhfaFtoT2ZmeQnoTMhFvIJFY2ijXOhKykcGUX3Z0bR3aVR9JjlWZ4TckW3i8as8AsnMaXTKNocBxO47EAVAlEQA1sgLnoBB64w4tooqj2iKoNbUAI3OGrPdYFu0AP6wTBwwAgYxSf/iNtmlJ5/xZ0JcbNofhtFD9OovsAH+JTgoQQvxMVyws9G+VpnhRyj9G7BKF2poVNFVUUVB+i1lEAZlwNgEIyCMTAEhoFjlK+tL6cz9vnYl50RSNv9NTbpa632Zuz7/u+Dk3kOpdKamvnEi5wXeS+KXlRsCLmptG4i0e2N9HvprnlZL9hz9v/bKhWbSiTXIwEnEFzeWI6urP4B",
            },
            {
                name = "Luxthos - Feral",
                spec = "Feral",
                data = "1|NZBPSJRRFMXve/PeN2kLN6Keuxq18s8kSSs3sxuFtkEyLqVCSgdSEFJE0i+wEirFP60C/UIRxDb92VQuXVSICII6m5igMheuBBeCnuFz87vnvXPv4d331D9ZqHk0fhy+6VExVdMqJrdFNQO3rWKKbfAZ+CQ84NM0plRMvpxqVsV0L8ENwU3AjcBNqpjeNbgXcM/gnmPUwg3DLeBtPw5+wz2Gi1RMXy3cO3wuqphCl4rZf3ge9OsmPOerc/AR/BGCeRXTYxDMMfUPD5VUq0y4RtQTV4irdIXuexWz95rqL3FA/GfLBtU/qka+/SvxhfhGrNNIqdjbt86Xvltg8yHaK5C9Q6cB2U62cb5wQsXgKgbnuEZ1HfGSeEXwAflFIoLfQVCOIKNiPxpCVOyHFRX76bJK4tKuit38SSOnYidOeTdK7Kkkkt+JHzw2Ec3EDaKVSBPXiRaVRFldZMP4C4/go1QY51/8cG1Y2hDBHIL5ZfjkWGhNAI+4puOaievkWGi9KSVeqGJbyRs/zmcHBh/cS7WkOu4PdPedAQ==",
            },
            {
                name = "Luxthos - Guardian",
                spec = "Guardian",
                data = "1|RdK/T1NRFAfwc+8De99rlyYO/Z44VCO/Jbow6OJi7B+AkZ+SR8JSSAhgCJuRljgA7i6EdDA6ENgcjYNOuMAmDJQf0kLZgI0E8r0tYfmcc8999+bk3LfQ/LGUmS4FxS+D6P+D/t8qJrQq9sc6XFXFJGpwZRVjrxAtqdjXm1jsQbSMMK1i4gkVm6mSE3KqYlwaURuiF3AHcPtwx5h7DHcId4QP47yRHyVO4PYYq3BNcKcqtvc5XA3Zlyp2+5J396kEYYCowsUb8hapGKkVJGMkcyo2d5/VATJEhsk7MqJi8j/JLxWzq2xuj5TJPjkgh+SI/CcVUlOxD76R7yq2lRvtqyp2q1UlcP94/TibPGethdmFit14z91r9izEkCbWdlSCxCb5y2UH6SRPyTPSRZ6Qbh579FUK/g38AxjmmTNEn+2Cn8LdhBBVsgU/c9/aw09I5pCKfTv1QXGwhTW48nzRmntw1XoM0/UYLTXicj0u9vjoH/w2S9Rus7hvvmibjf8NGjW7fdmoBWHgs1Iw9WpmNj+W7c7mZkdnxvKjkzc=",
            },
            {
                name = "Luxthos - Restoration",
                spec = "Restoration",
                data = "1|LdBNS9RRFAbw8z/jK7R3nmOLufc/gqaiVKhgkpJYvo3oojYtGtFABhRG3TvMYNrSldtBbOMH0EWrWlQk+IaKBupMri37AuqTs/mdey/33vPcmytfyEfT+bLs6luEH+EX4GvgO+ENHvBRhHsmQXKffCXfyTfyi5ySY3JCDsguOSdHZJv8JoekSC7uKCxydAbXDfccrh/uFVwf3EvcrMF1wQ3i5gquB27YREdr4RLY7DPRxw/ICFkhhwgTCAsmwfvXJtq2gfodXn1JfrDTBxN98tBEn37hhkkTbW8z0Y4XCJ8hXsT1Z9SlEL5jowkTHQpM9LjKJFJ1Qvo5rTbRqwgZMNE/cZIy0b85E71+Qy5N9F8j2eKxQXJqosvrJpHKn2Sbaw3kEWkhraSRNJFmk0i1X5MMwr1YrtQ/SJ6V4gSFRbfE4HUpBo/zR8eL/6PfP2F5/RN8TSarQQV8lDWAR6laab3zvoaJTFbLg3zZbG96fmoi1hwbm5ydm0kn56Zmpm8B",
            },
        },
        -----------------------------------------------------------------
        -- EVOKER
        -----------------------------------------------------------------
        EVOKER = {
            {
                name = "Luxthos - Augmentation",
                spec = "Augmentation",
                data = "1|NY+7TkJBEIZnFzOvoP8kJtjZkGBpYZQYnwB7hQSVGMEYQI2NBG18ArznxMbOJ7DTwlhpIuAFFOFwkaiNoTYDh+b7dmZ2s//sDe06I/uOL5efQXkB3AK74Aa4CS6CC+A2uAMugV/ANXAF/A6ugn+F7PwO+E3ITt+Ay+C6tq7Ar0Im0lS0wJ9CJplXHIJ/UL4TsqEvIbM4qc0z8Df4WcisZBSbQibaFTLrYR3/6WlYb8e1PFLca7mkiOmLLcW2Dk4V56gEhey1I2Q/RoWsS0K29aQoCNmTgJCtTgjZ2rjiQfEoZOuzenlKyB7fXphsbwebRSU4djCI3P9fIw9y9AOGeyn7a0S7l+BCNmcNg4ueS55dzw3PTc9tz52eHV96LpNcjW34A/5QenktlkhFUvFk4h8=",
            },
            {
                name = "Luxthos - Devastation",
                spec = "Devastation",
                data = "1|LdC5S2NRGAXw777o51IKiuerop1LUNBi3MGlsdG/QLFQEUEHJyh283ghduKG2AqBuDQWFooRBPcYRS0s5TEzhf+B2A3nmeZ3uAfuhXtSpb93awM/2BlFehnpfmgOeg49gZ5CL0zczx4Tl8+aeH3rSB+xqYHeMruhz9AC9AlllXj/hN6z7oDmoS94P4beIbxm94N0QS+hVybuz1+sLiGsR+hM3HTWxI0Nm7jxajKFcID1Hjkgh7y+RtbJBtmE3ph4X/sIMzxvmbjbLhN3d0ZyJu6+l/TxA22knfDV/D7h04VmkiDj5NXEPZaYeP9WTLyPbZNY+Qh5M4lVVJnEyh5IgV0DaSQtpJU0kWaS4I36jAuiUUhntIIXRDvcIMzEU9Gu36Ny3Fj5W52PcCALPfEDzyn0tJi5Yp4X86KYl37glTroVZR+cmhxfnZyIZ6ID04uTvxKTiRn5uf+Aw==",
            },
            {
                name = "Luxthos - Preservation",
                spec = "Preservation",
                data = "1|RdC/S0JRFAfwc+95lKOBRN8z6dZgmw5FZBFtDQVNmanRE83yx7Oc88cQDc2Bg0iDi1tBS079DT03p6DJpcFFqLjPBy3nc+DwvV+4beu2t9JuTluPm+BzsA3Og7PgDAJxBGLgKtwxuAe3I6RUCJwGR8E5IXXiCOnEr5De3sAoAr4HX4FL4AoWV8FF8CWsZYz64AtMXjB5BtfADngmpFJRIVUawdoXUkvfQipzJqTySXNLCumdBGbrQur4R0glX01jyNy+zLZrwgMzPsxwYRVMOGXGqZAqHyHYNR4K6WFRSL8NhfTn+5NqYNTXDQS7kTuvxcv/PwergNmDkKpseUUDcLTR0moBnPbN+GZ9c75V397cQMw3Ptft+I49vQ/1tub0Zq9eLtpOeC184Ng126lnrwvl0h8=",
            },
        },
        -----------------------------------------------------------------
        -- HUNTER
        -----------------------------------------------------------------
        HUNTER = {
            {
                name = "Luxthos - Beast Mastery",
                spec = "Beast Mastery",
                data = "1|NdDLSkJRFAbgtY9U9gatBbtOgdBNEl+gkIwE7Ua3WVk5qEEDtdKNlXIaFBVNChoZmb5AkyaFzesNug4ad9GxEP+JJh97weZnrX+vKX/Z1lFwzqOcLXH2RsgKXXDuWsgK3LGxWUdZz7Ie41qG9RzXP7n+xbkU6ynWMdYz3E6sx1lPc/1bSA1rrhaF1MGQkMd7z3qC9SSbMpuKkMrE2Vdj3w/73L+r4ERIhRtCaqRbSK1lgAE5sA12wC7II2QBLIIlsAxWwIeQ2n8Cz+AFvII38I61BoXU4a2QOjoTUsdeISsSFLJOw9h3HjTAFsgLeVoewCPGHtALBkAA9IF+4BfytHZdWQ6b8t+ppmI7bgtuH1wtdjr/qci3IsESG7vgWKrZrRsvVdgc3VhPJ5K23w4l4qm0HYun0olk9hc=",
            },
            {
                name = "Luxthos - Marksmanship",
                spec = "Marksmanship",
                data = "1|PdG/S0JRFAfwc59Y7wnP1c6F4NVUmtQf0FZBSyBtZYuDZb+kNEFIKX2W/XjSkJWrif0akxqzoKFff0EITQ3NglsQ3zu0fM49514OnHML7u1qj5Xv2JVp1m9Zb7Dhk+TqLrHeYsfPRpXNIzZqHHtm84nbL9x+ZY+PjXM2s9z7wJ5uNjPcfpMkxhvczEhy6Y+StM8x9ujsMdhckSQmNtmJsncUr+7APYoZkJUklopgD+RAHtiSRLqMUwHsgF3UomAeHIMT9oYQT9lLiGegAr4lif06uACX4ApcgxtJ4mBdkjh0JAknIEmUipK0gS9JWvMHg8ygywJOcyAMfsEs2MKi3sEH0kHgB8NgBATAEAhKchn9Nc1W2/jvG7ZstSy1Nm5m+grsDalBVH+RLtdZb+VsTXSx4UMU7PhVrhrlbM0t1Iepu3wnNZmKb0QTVtCaiiSWk6uReDK2uPYH",
            },
            {
                name = "Luxthos - Survival",
                spec = "Survival",
                data = "1|VdE5SwNREAfweW/x+gLiDAxJBAsTg/aC9xFrSaFgoZIiRgTFhBSCxqTK4QEWaVNYeYDYeSUqVkY/gJ2NWmoEGxHkv4pg89vZhXkz77+ZurVSi6/kpIth1gkh27fCOilkFoqsU0J2JsS1IGuItY9rYdYxjlX4PSxkZ5s5dsk6xNrLOsr6yrErITOXZc8xaz/rCMee+X1VyAz7WXuEnMaKkH24Zh1gHeTyDXvehEzyRcjkq+AO3HNbN5oCIChkRg7BIw7PgwLYwHLu6ybYAts47QScgjNwDirgEmDF5JOQye6BfXAAMCN7JGRyH1giImQKYwjkAh1lHJ9jT03I7uSF7GdUyGlqw6W+sElByGm4BVV8awd+0Am6QAB0gCB6W3dp3Q3YTd2k3Oxsyg3Em/4XmC/zMxn3dUeZudwu62QqbY1hncKzHj8t8VcVfys7E3KrkrMYii8sR5a8Qe94fCkRTUzPfwM=",
            },
        },
        -----------------------------------------------------------------
        -- MAGE
        -----------------------------------------------------------------
        MAGE = {
            {
                name = "Luxthos - Arcane",
                spec = "Arcane",
                data = "1|LdC9S4JRFAbwc18ztS2IS8+R0Nr6sKJPtJA+aEyKxiIwk0Ao0Gjp+0WJsH8g2qIpaCohyqGmhgp0bimFqNaGKIWo8+rye+7hcO/lnJR997hx2kweTjHZXBNI/yBdwoEHKAMlcAp4AQrIxaDHoftR3If2I/cEPQQ9jOI88gQ9Aj0G3Qs9CB2A7oPugQ5CD4AjTDaHk0k918AdZ1ILOSblv2ZSkU85ZZlUoEE4YlJDHiYVdDCpvRvwIvgO+ZBUt0zq/JJJXawLG8KmsCVsCzvCGZPK+IROYVaY+//n6k14Fz6Y1P0rk5H4ZTJWs8I3k7HWxGRkZphszi9Zh0uoE+pliAfhUbqtQpvQJXQL7UKH4JMbLSeGCXfca1qvNaescZEPVWY6BV7MpKFqgUI1S9UsV5IjZtKwK3CqUudiVlp7tDrWWq2TuTwZXop6fd7RRCS8Ev0D",
            },
            {
                name = "Luxthos - Fire",
                spec = "Fire",
                data = "1|NdC7L4NRGAbwc05Tt8HtiO973i5lkLg07EKitHFJ07CaSBq0StRQo7Zi+f4BMVGDP4BgEKKJwWWw2CzE1ISxszxfdfk970nOyXnf9yC4f+ouFWuloyS8DLxNOCeiTHQAThleWlSgpQbnHesh2CXYGXx9wM7i7Ql2HnYB64K3Z9gk7CJsFDYOOwc7DTsFm4CNiTL5LNyYKH14ByREmeUqD4+i9PgFuSRX5JrciNITx6L0Kq9MforS6W2yw2cPpCJK37aTDtJJukg36SG9xCEuAdwoU0hIlL7/hrcBt02UyVVEmd0JdhohW+SH/Ioye1myJSrQ/EJeuZJBMkRGyRgZJiMkIirQ2n9mSv6c9aHz2XCxvkwv3Xfgf9zoIXoOp1woGd0E572ebqxQMkENJPz0l/dfmeVqo8pn/apYyyRW1lLhSDi+kUv9AQ==",
            },
            {
                name = "Luxthos - Frost",
                spec = "Frost",
                data = "1|RdDNS5RRFAbwc++rmav7XnHhcyiY2kSlOPgFITazaidF/QXixLsJA8dmM1IzjrhxLbgKJsLAWrSuN610jNDN/ANRNFDojB8wuI5nZqTN7zl3cQ73nOXuQnngUTkorT/Eag2rv9HfqxJcPodbhHuhYmcqKvbOGlweroAohegu+rYRHsN3ITxD9QpcE34UfgzRFKpX4R+g7xXCOsJT+BGEDfj7CI/gJxCeqJi5JKJZFZPeVLG5jIqZ/EP+kkNyROoqZmWH7KqYH9/ZUeOzqmLiD+QjicknskW2yWfyhXwlnBJzSlwhe+Sbitm5oWJ236uYylvyTsVO9qvY7HMV++wl+Ul+8acbpKES9DqVoGefHPBYN8ktMkyS5DYZJEPsuP7aFOGaduli5fRmYrl9aD/ePvu1pf9rvoHLF0vWXIJb7GShnVGqk7PFku02rUmdyuYyraocPJmeiR4nhhL35p9mF/4B",
            },
        },
        -----------------------------------------------------------------
        -- MONK
        -----------------------------------------------------------------
        MONK = {
            {
                name = "Luxthos - Brewmaster",
                spec = "Brewmaster",
                data = "1|LdFNS1tBGAXguRPTxF9Qz4DkWoV5jRWLP6Hb4qJaXSml0ECrxrQqt9teIl10JdnoqhLciZsu/BM1fkA1TZW2yrgWwY80idRyxmyeM+8wDMyZpeTHclcuLq5OIZpFlEc0B/sP9s6oIHOOqISoAGlBFETDDWNrBbYFewt7DfcD9ga2ATcJ9wmuCluH/QtXg23CpeDSRiXSE5Br9HdD0kYFYQ/kEpKCXBkVvDyBJCE3yF5gYAhyC6lze9uo4M0yVztkl+yRfZx1QJpcficH5JDUyE9Ig3lEjskv8pv8IafEGaW735Jpo3Tmm1E6fEhek69G6d5NUjdK91WN0u8qRunyMz7mC6mRUTJGXpBxskaeG5VIbZMKx36SJUPkCRkgj8mgUYnOR+s69m2Esb++57Ovgs34C1mPNHxDdUgTZx0bsHdxUQcPIKqdmhlAEu25dZ9RoZ2l+3TD/pz/X7/jvygu6mQQvx8pzM2Eg+HT+dyH/KuFxdz8fw==",
            },
            {
                name = "Luxthos - Mistweaver",
                spec = "Mistweaver",
                data = "1|NY3PLgNhFMXv91U8w5y7qgdwZyRewMKypq/QRSmSij9ha9oSEVRVxUpKRGLTVms2VqYSdmJBN6KsJIJkVl3L16nN75eck3tPYWj91JrO9fLH45AdyB5kl0ml6ga+wbXBlUHLoAkpQkqQfUgZTtJkDUgFbQuOC2cK9gNsD9KFvMO+hD0D+x72C+QI8sakmhNMKnPCpFodJu0+ManGJ4JXE1cNzhCYOugwqTuzcDuJ8JlJPdYxNsekultMyo8hrDHp320mnd00+GbSXwdM+ufmnDw4rt74X8hUo9P+UtyDHI4UENaiv34M8nEBKXp5rYYhpYHLA1ciO8nIbavvXG8xsZCdj4/GE7PLK2vp1Gp66Q8=",
            },
            {
                name = "Luxthos - Windwalker",
                spec = "Windwalker",
                data = "1|RdC/L0NRFAfwc+5L/VglxDlTGV5TNPwL4sciEouaKwSpVDWct6qKrZO0qbZLYxBU/wDjG8uuHSqxoomJokRO+8Ty+Z57T3LvPffId1Aa3ihZqdw0A0aulDLJCUmGJEuSJ8kx4JBNUiQpaPuaweqraVUhx5B8MJjnV5JPkm+SH3KQnAC5cZIvkjeSd5I2SYvcNDlBBlxdYsBGixybATfLSoUB7/cZsHau1Y3S0OWMMqvMM+BDWAlod0/3qgw4cMqAg4+6nGPAepPBNMMMJrHAYF6WGUy8zWCebAart6rcKnc6RVAZUyaVKWVcmVBCDFb/6JlJkmP7D/9HHzn+u03v7RzafUa9Se7lBUkmmTLYQ5L1Mudl3suCl8VuOkYTyU0nU8aHne/udErW7uJOLOoP+Ve2YmtOZDu6nvgF",
            },
        },
        -----------------------------------------------------------------
        -- PALADIN
        -----------------------------------------------------------------
        PALADIN = {
            {
                name = "Luxthos - Holy",
                spec = "Holy",
                data = "1|Lc+5TkJREAbgOfcEl8TKxOKfCuxciDaW9jaKEl7gGhsNwWSksfMAronVdaGCqKho4hbfQn0BSSgoKL0Ye42Zy22+f4rJLJXEzsWYq1TnIYuQJcglZAWSgdSYrGlBspAuk/EryoGyr+wqe8qRcshkh54h15AbJtN+g9xDGpBfSB1yi/AVcgdpIpxjMk8BwgC9HCSHcEsHHDOZjUA5UU6VM+VcqTKZhw6TefxmMp9l9DoovjB5f19M1hvRW9tM1qaYvOIqkx18Vz70rAllUplRZpUpZVpJM9nh8YZxkLrnokHJUvzNVarU39SEZFzZMwOQbJy1OLv9DANX9hIGvVyU0Y9xZU0r6nFMoz/iCst+3l9bLyTTyYXN/PY/",
            },
            {
                name = "Luxthos - Protection",
                spec = "Protection",
                data = "1|PdA7SwNBFAXg2QnxgdoGzlRJrDQR768QX2BU7I1PImpAs4lvzG4kaqHYaHxhYlJYWtkINpb6EyxVSJkmtZx1SfPde4aBGU4heFgJOU23NIP3bthbsLeN0m9rkDykCHEhDqRglNU1BrmA2JADyBbkEJLjcS/kDLIP2UO2B7IN2YHsQrKQE6N0PYT3V9i7Rlmz02SEDENOkWtAjpmGkI1BzvHzwjRKxskESZBJMmWUtVIlD6RGyqRCHo3SWDZKmyhJGqUjcbJEyqRCeC/yZZSOTpCEUYHgN/kxKtDxzG2OVBkvyRUpkWtyQ27JHbk3KtD+QT4Z+0g/GSRCYiROBowKdEZryvEK9ZrWR14h/1WxMr+i6bDjfQj2TqTYKghyzOp+I8g1niD5vKutNojjT9efBX8Wvek91to2/U3XQ3lXBy2nmUkkV5MLqfXwQDixkc4szmdS6fU/",
            },
            {
                name = "Luxthos - Retribution",
                spec = "Retribution",
                data = "1|NZDLK8RRFMfP+f3yiizpnNWw84oNCzuy0BzlsfBjSSxGomQoRcbPUklRlqa8yaMsSBqSkjHeawuy9Tfoe81sPufRvffc81nMm0+WJ/1wPSp2JZZR8gtPxO7EbpQ42q3EnbNi92LXYimxD+n9EXuV3i8JpsXexN4l6BN7lmBKgn6xb7EXCQI5+1Tio2Ulnsko8aEvdinpObELJS6+VeKTMiUuaVTi0iYlry2uxKc4O7IN7AEHSnwgStyRQLkF7AC7Sry/DvziWhpH9lHi5aNm9B7EzjGmBeNXlPh4CO0nJe+zHUgBITZeBdaU/KJWZBtKfkEaeERZBVQD9UADUAPUAnW4VrlJC06Vk+aFbj7w6P4eCbNeobhiyUn4Xxir86GfM+GcwJpfuCF2mbNXfCvpuR2xVCL0OF/sOhvvszHjohuVCL08dtZy2emDy5J+vGtgdGAoNhapi/QMT07EBuOTsfGxPw==",
            },
        },
        -----------------------------------------------------------------
        -- PRIEST
        -----------------------------------------------------------------
        PRIEST = {
            {
                name = "Luxthos - Discipline",
                spec = "Discipline",
                data = "1|LdA9TwJBEAbguSXoepDciQ2z1UmhfJ1gNBELTUxITKj8D4aCxAgRbaw8QDR+xkpbCwtb5UOwsLRQ/gG2iq0djdH3uOZ5s5nM7s7U/Ae34QWnepNl2Wb5xMF9ls8suyw7LJssGyxbisTqkiKRGyjS7HlFWtJh45ODU2wMODTDwXU2vtn44lCdA21FWvGa9aIin8yxGWVTVySWTUUi0+P+Ivpr4BDUwRE4BifgDJyDC3AJrvD2LIiBOEgAG8yBFEgr0kphRWLlATyChiKxJhSJ3xd8aoj7ThX5JlKKfONv4B2FGIgDFGQaJEAS2OiI3FHF3QfLpuZwoC2qbEbdC9nUrYq3IZ8cTtcUCevHHd2dWmR69ywbTlVoY//dXra87HjZHaVedKrCr/Hk6+jc3xvlR8RNp7yxU8iXdy3byhbKm4XSVmE7/wc=",
            },
            {
                name = "Luxthos - Holy",
                spec = "Holy",
                data = "1|PdA9SwNBEAbg2Tsvbs5sChHiDCghRBMTgyFoRMUIVgGbCDbWYiEogh+Fncn50VnbaUws/MDCykZBBAsV/AH+BBsbg+nkTU6b52WZ2V1m9pzdau9opeEdF1l3sZtkHWJtWLts8qw1a4d1gHWQ3TS7KSGrcCukLk6ErLk4Z+85+4DzqZCtm2wKbMY5fM5mks0EmykO19lMo6MqpOI5jhB3v3PPC2/OcmRGSCViKDyDHyE1kAJH4FtIDSbAIvhC8wI4AHdCKtkH+kEJzANUlz6E1GEH+MTnZ6AG6kLqaltIXY+BJyF18yhkB6NCducreMMsQyAFRkAWpMEwyOBGrEbl1kKs/f9pWmO2R8pFvb/92Lp5ydope5YKsA74qf0M+un6GfLTtNNNt9PkW9l6uuxZjqo01kobK8ubW9FMtLi+uvML",
            },
            {
                name = "Luxthos - Shadow",
                spec = "Shadow",
                data = "1|LdC7L8NRFAfwc38/+iISm+9NfnHjkXjUY/BqQqQL9X60GCyatAkGTZAwkKiilk4GBqKV0G4dOjD4AyT8CUZ/gMVgIt8fy+fcnJtzzr3npPqo0NBfsDNXqzCWFnVzQA4RjMFUwdTAeND4A1MLo5APaVHZVi2qeALjQ3MATh+cEZg6GC/2AeOHMwhnAM4QnGE4IaxdsCamxfZ9o21Fi7oPIBlGIofgixa1meT9GBknETJBJskUmSYzZJbMkXmyQBZJlCyRZXJJnrSo22tOLJJ3LeqhnnDaQ5l88C8g7Fyc02KNCk+n5IxkyTl5Jp9aVKlFiypzGRVF+L7KDOKPWqyRLZLSYkW+tFiTNVpsf7cW2/tK3riIdtJBekgv6SRB0sWKpjsrg+ALEjl3Y+bYXaTt+y6h8SedsZQHRv1Hz3+s/YttK+mMVa2QDP/FfMjNu33cTMFOzW9vJHd2TZeJrscTqb1f",
            },
        },
        -----------------------------------------------------------------
        -- ROGUE
        -----------------------------------------------------------------
        ROGUE = {
            {
                name = "Luxthos - Assassination",
                spec = "Assassination",
                data = "1|TdHPS1RRFAfwc944WXuDvqfNKLTwx5AbJQgsq7WLNm0dQ2PUdPFUzhOhZsYhnhAEwjBl0DRONuCuNBUXufZnf0juml1SfF8u2nzOPZd7zzncu5x++fFGd6FUfQpfgr+Al9EaNAn+tOAL8NBEK+fwCmOKtJE0ojvwPHwVq53cGIOvmGjuN/wN/DWifkQDiJ/A19D6heguXnUh6uXRn/CiiY5Om+jEMRYnED0y0fqBib6/zs1DE13bZ9qBeI/JmIlu1tEYYlwnDROdynL1iWyQzyZaY4+pe+Q+ohHGYfIQcdVE3/UweWCik1/Jlom+vSAn5JSckR8c6Tv8uYmum4k2eb7J881t8o3skF3CMevnnP6I6TIpky8scNNEP7BNjf1rfSbByS2T1NUtk+Aiy9W2Sar9iBwz7SY95DbpJ72kj/DGta6GFC9/qhKU/nvF0elMMSkOL3aWk4dCXEVjCNEI4r0NeFgoBXoFvnAZK/9iazCJSYlCKUhr8vvJXmH+8eyz+fFMNjMchrkwzM/k5vKzM38B",
            },
            {
                name = "Luxthos - Outlaw",
                spec = "Outlaw",
                data = "1|LdG/a1NRFAfwc19Q238g9nsWo+Bg6rsKjlXbjgWlEJJMVhqkdYioQ2I1g22TTt3exUGwg81LYl4zlVoFtULoqAhCC/52Erq41kEE+b6X5fM9l3vevdzzVo4srY9k64eNx9dhr8BeRduHLcDmEU3BFtENVbzVHURrKmb7MrkIdxzuNNwFuE0V8+Ip3CRaIdwwgr9w0wh+IthF8BGtAwS/4WbgynAP2LsOfx8uVEkNPVcx5Ufo/IEtwc6qmPlr6KXQ/IyNMYRp3jVOJlTM3RusJtEsqZhXFX4aUyX3yH3YnIrp97hYILywXFMxL7+omOgr+Ua+kx888BJqWyrmTYGti+Qhz2iRDnlG2ipm9hd6T1TM6yH250mRexHZUDFvP6l4//ZUvA8n+Lxlsq2SOvaOvOfyDMmSc+Q8GSVnia+SGj4VevVkJplGPKVkYCdXEKY5mngA/V4Em19ueOYobGGQxSTbfpLdMMloapBrcca/cVB5qztxVT+8nbtzszqX8TPT1cqt0sJ/",
            },
            {
                name = "Luxthos - Subtlety",
                spec = "Subtlety",
                data = "1|NdA7SwNBFIbhs7PGS6NI3CTf8UK0EV2Ddjb+gWAj2liKIEIQFE0KncaYQNxik8UqpAuYgGAjKtYK3mMlYpHCTgsbESGVIierzfPOFDPMnGxguxyxy2amOI3dGTgfqJSYjIVX6D4ms/0ErpRycN/gxvHYgLaw9QQdge6GBvaemVTnOjSj8g4dhg5B90L3wAlBB1Gdgu5H7ptJfR2h6jAp6xN6APl5eHUcTjIZiXPhQrgUroUb4Va4g+chb8vyXqgJD0yqqxWFOpMKEryEXBxjUqEzJhWeFl6YVGSDSdWKcuSKSf10MpnmJZPZMiUcyy9/hFMms+1eqMl2RBgVxoUJwRbGhBiT2TG0Tzv+cLSl0jicjGZQGP6f3GAWXkJeXqgjbx9g6ymdUUYrtOXX+fDr9v01/tc3v5WS38dGs835pTMqYJTNtdnV5dRSNBadSy0mV5aSm78=",
            },
        },
        -----------------------------------------------------------------
        -- SHAMAN
        -----------------------------------------------------------------
        SHAMAN = {
            {
                name = "Luxthos - Elemental",
                spec = "Elemental",
                data = "1|NdDbShtRGAXgvWeMxlOvPK0NQiqCmBoT5d80HhCExgMeoRe9MCpBxSgqKj6AYaJUxVaMF70Vwbu+ggcYelFFn0BfxFNZ03jzrdn/HmYWfz60fdowmPN+LUO+QPohXZAkpAfSDemFpCB9RmnfJSWQccgE7AnEg/0OuwcZg0xChmB/QkYhA5BB2H3IMOwh7A/YI9hj2ALsAWQHsmuU/vyMqQdMPULyRrnhO6Oc6BPS80bprhjvX8greTNKJzVxiIuZRmYIc0vMUlJGwqTcKJ29RLqSeUWuOa4gnCWrSDX5QGpILakj9aSBrJMNsklu2KyFtJM4SZAO0mmU3vrG9/7y2Mz/XnD2m1tjRZ8VfVb0WdFnIZ+FfBb6s8gtFMg0mSX3RrllN+SWx1YSJXGSIJ9IG4kZ5ZY3nTm7xRJO9Om9SVAi2Gr2IrIDyb+vfiRY/UcPc0tIV2Km8RzSm/McXQrpK2bqf6bnc54T0sGHik9uuBDc5Ta/ZjOrmbVILJJaWVhdWNvKrPwD",
            },
            {
                name = "Luxthos - Enhancement",
                spec = "Enhancement",
                data = "1|NdE/TBNhGAbw9/saKiZqIqaJzztVF+OfHpYmJLTpQc+YMEDVoO4FSUpIqyCJugkF4+Lu2pg4OJCYgNWiUpVqFIRBQIeGiP/dTAccXMxzheX3Pt9d7u69951sulk82D2xVbh7FU4WzmVEb8AZhTOCWBVtIST2wU0jOQu3jkQPEhF0zSJ+ScWk+lTsUAGpKcT3o+Mv4t1wW5Gs894ZcpacQ9c1pD4z9pBe/G5hTcNLIFpD8jo6Z+DmVALNyyrGK/PuhoqdDqqYuX4e59B+hfUpeUbmSYW8IK/IAmLDrFXymrxRMUPnyQUcSbNe5OW35B1ZJEtklaypmDK7SK0zrTB9JJ9Ijfh/skm+kK/kG/lOfpCf5Bf/5TF5omJKRSb267F9j+17Lwk79xZUzOQeppKKeX5Kxcw/UjGVfyrmQ0bFrDaThypmrUXF9t5RsQ/+cErvVWy1wvH1qwR2W6YVlcCuRbLE41FyjLSSk+Q4OUEifOzwPTu102Jj5hvbXzClYvgWl+Xm0Dnjr4lLi9YO3UYg5I+psZ0DexszLi/D1hEbvg9nZLxgTRBtoUaNVf3qv328YJuMv+/tZKeDfprYGuvLZnKZfDgSPp3PZvIDg7nB/Nh/",
            },
            {
                name = "Luxthos - Restoration",
                spec = "Restoration",
                data = "1|NdDLaxNRFAbwczPGWkRp0gf5jlpTrdrGTpv6KD5x5WuriHU5asEsbKHmLGVmbKLgC60K7iS404UrS2OhuG5EofhHuBU1QVfyjePm913uvdxzz6llo0bhfMOrvazAemA+LAfLw/pgvbB+2ACsgKit4j42VNzqKxhgexH+hI3AirCdsEGYInwL2w7bAdsG2wfbA9uN8BfCNsIObAg2ivA3wj8qbryJqINoXcXb9FnFNVdUXPkxvm9BHMAuq7j567znk3HELeYEmSQHyEEVV7nG1SFymEyRI+QoT69ydYycICfJKbKMeI0l75MH5CF5RJ6Qp2SRPCPPyQsVN3manCFnEc2ouPerKm6ph+RInvxQcctj7KxM+OkPx3HnkkrmXQlxHTYNu8L2F8kXNpxT8bpa5BP3RkmJTJAy2U/GiK/ide96nbn7b3BxnbNLH3XNlWINNoyokwwY0fpQHfEa4tb/2SIO3sBy8ULGbYTl0+xNsy/N/jQH0iyk6SeZVI4XMlmX9JHs3VPJfj2n4pVGVLq2fsPmbtxeUtnQnlLxBssNr3rxRnAzmC36xQszt6pz80G1Mjf7Fw==",
            },
        },
        -----------------------------------------------------------------
        -- WARLOCK
        -----------------------------------------------------------------
        WARLOCK = {
            {
                name = "Luxthos - Affliction",
                spec = "Affliction",
                data = "1|Pc+/S0JRFAfwc69Y2T+Q5wxhDgf6IbW0Bi2Z+Ac05BIvH1iWGA6N6ZOXtVkODQ0FEdHkXxDNZr+oSJfQQSKIpvJNSpyXuXzO/V7u5fDNe3dO/cu5tnW0gIUNAmV2hC7yKxaSyHV0TIxEkWvoxNHJIz8gPyHfIz8jV5Cr6KwiPxLo4UPhAPmFQJc66BjId8i3clskUI4tlCWW5BQjUD9d5BaB+rpGfiNQa4pALY4IfomaQIUvJc4RqI80gfoMCmH5tC0cIzcI1PcscpNApw0CfWILu0JB2BP2CfTVOYF+rxB4hsoEHt8ogWfwRqjK3bgwIUwLM/IkJKdJYUqQ6AueKeu/canj1ta2W6ffzu7Xjrm1A1l36VgOuYHcvECuZS2tBpDrvdnKWtqrMBL9y068N83ezLvT3eK+zLUzSytbyZSxHggF5k0zmTAyidTmLw==",
            },
            {
                name = "Luxthos - Demonology",
                spec = "Demonology",
                data = "1|ZZE7L0RRFIX3PTceZ8RjChPrVNeEwmsILYnHEAq1SCi8IhgmEY3OnauYUkMkCqZQSTwKGonCq/AKIvwCv+FKJMi6d0Sh+dY6Ozvn7LXPasFKrmrE9TYHkT2A2kbRqRHVl0FpHJETI6p8DSXvRlT0GH4Sfi/8LmT3jdjFh9DL0I/Q49BPsMtQ/AC/G3rLiKqYIWYRsYyo9Tb4PdAJaMXqHG+boEvRjROTfOkMtob6MKISZ0bUxjBqBTXPiFUasfpf4IxSX4k3I9ZsO9GB2D3UpxFrQHgTZ945Jy6IS+KKuCa+iG8jKsfmHKe7GCM4xQ0nu9kzYutOI3bRLXHHqHVEPdFMtLClla6BaCSaWIvvihvsyvKC3H+bUNkgehgvH/f/HjaGnUy42ux+tQdnFLEjxO73oLZdT1mFsLXrqQILkZPwXPIeamk8VL8rr8m89gYa/OOvix7/ur5M4NylobHFVHpizmlyklPz6YV0Kj29/AM=",
            },
            {
                name = "Luxthos - Destruction",
                spec = "Destruction",
                data = "1|TdG/jhJRFAbwcy84LNQUfKdgWbXxD0FfwD+JzSlNNFsZYYkGEUFZcDUgzs6g8gC7uhotJtmYaCx8D0yMiTb6AvbEGRvBnJkxsfl9557c3GS+mR5xg9K1IOsfXGWy3i/IB8y+YvYNv0uQHsSFtCATyAgyhhch9BGVmYx9wpRZ+wgZQHYg25AHkC7kLsL3kCGTLdSV65CHTHYvh/ALpA+5p9stJps7rlODyTq6cwLIHUhHlzUm8+ctk1kuIE8hz3DzPsRjMu1zTEZ8JT6e1+mx4urxApNZXWay2TmTzX9WVpAppM1kXwdM9k1RuaLsKfvKc+WFcqC8VF4p35UfTPZnkSmTX1eO6asXmTK5ufJJizihnFRqyhm9d1anU8pppaq7o4dmGtfxXzeFup39ayHuI2mmlhZllou0DusEFS+uPf4BGz6TJUo+7x2ktetb40BGaY7TfJTmJE03SS9KMvSTjMpxBtnhZqPf6TVvV6qVSze2B/1hc3Cr1/0L",
            },
        },
        -----------------------------------------------------------------
        -- WARRIOR
        -----------------------------------------------------------------
        WARRIOR = {
            {
                name = "Luxthos - Arms",
                spec = "Arms",
                data = "1|NdG/TxRREAfwee9yIqE1cWc8cQ8qFSIWRs1cAcnR0BqwsbEi66+VlZDgHeR2bwUTQ0k8uAvx+JFoZwwNRLNoKxqNxEr/BrttTAj57h3NZ2beS96bNy/O19p9UVpv3HMuOAUhOzUrZNqTHB9waYbVd4R1lzXiOGFNWGtCZu6PkLk+A5qgJZQ7+57Lb1nXWV+z/uSPo1x6ytp0+jn+wtpibbCusf5g3RAy1Qku+ay/WI+4fA43rgrZ57+FzMIWjvyH7K+QufGA91KOPwuZ8LyQmS4ABwi4CIpgAAwCFjKHb4TMt3Eh872MbAksg5c49TZ4CB7x8SI6+oQbPSGzeYf3HSE7fxPcErLpjpCtXAIu2lzBRgIOsPYfWQVUUX4AHkbySijX8xUcorwMroBrYARcBUNgWCjXO7BNYfYJ9kX29tNR4NWn43HDbNzFqNNmxXvnSFi35gyrj2hYa9066sbdbkw6Me7E7PCwbvMm+9NsLUqf3L0fBJ4fuMPuWPD42Qk=",
            },
            {
                name = "Luxthos - Fury",
                spec = "Fury",
                data = "1|TdA7L8NhFAbw9/03tBIfwHPQlIGUVkvVvS45+AoiJlNjQNKkgwGt+rvFZegiJiKuk6SDRDSRYCKRdBfhCxh8AXlag+X35Jy817NelTmpzeYOp6G70D3oPtxGaASah0ahXXATcP1ibOcjeSLPKKXF2NMNMR7fDcY3oD3QGHQI99fQMegB3GFoL7QbGof2QQfF2JUH6DB0BPqD4hcmRlE8EmO7t8XYzLEYmxwgLaSVcFMyRMIkQoJi7NsZOSfX5IJckisxNnZLPnH/zcML5F2MjXvF2NVXMsMLO0iS/9gi27j7YO5wqU+MsyyknjSSBjFOJibGKZD5fvbqCIifs9jnAZtiPN4X8spekLSRCImSdhIiYTGemuZTZ608AhS/Arl/ky2lm8rlZuVtqzNn0Gg259hqaNdf5pkWrr9Su4lyZhemZlOpucVUIByYTKeWfgE=",
            },
            {
                name = "Luxthos - Protection",
                spec = "Protection",
                data = "1|LdC/S1tRFAfwe9/TxFhTg6XS72lifg/aSoWie7fvorZdMjmoiLg0EDKL4aW1tGo76hgQ7CJInEr2guhQOuk/0ODsUrCDfMNbPt9zufdy7znt4Z1OuhNGhzXwOZgDs2AefAQOgeNgESyDGTABhmDJnD925sKRM3RvQQNHwST4BL1/4DNwDHwMjuDPXzAFpsEJ8Ck4ie4PEGAFrJrza2/w/yd6ZfTvzfnNZXNB7tScv86LrMhp4514b87/jlStqGqLz+Kj+CR2zfn5O/TNXDD1Wosj8cucXyiIJbEoltVEYM7fpFR5vaUj11Pmgu09sS8OxDfxRXwV380F5xfmwlRFU9gzFyYvxZWW02JGvBJz4oV4KWZ1rXTsW+BYEIFV9O/BSqE1mGcxGnxm0IHfXDkBw1YU+ASYiHM8zkycxThLcZYH2QmbtdVGY6veKMwW3jbqzY315lb9wwM=",
            },
        },
    },
}
