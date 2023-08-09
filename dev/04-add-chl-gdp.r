library(dplyr)
library(readr)
library(readxl)
library(janitor)
library(stringr)
library(tidyr)

gdp <- read_csv("data/gdp_pop_tl2_00_20_imputed_l.csv") %>%
    clean_names()

# downloaded from OECD stats
gdpchl <- read_xlsx("data/8a291744-f95f-4def-9680-890e6c33a071.xlsx", skip = 6, na = "..") %>%
    clean_names() %>%
    select(year, x2005:x2020) %>%
    rename(reg_id = year) %>%
    mutate(reg_id = str_squish(reg_id)) %>%
    filter(grepl("^CL", reg_id)) %>%
    mutate(reg_id = str_sub(reg_id, 1, 4)) %>%
    filter(reg_id != "CLZZ") %>%
    pivot_longer(
        cols = x2005:x2020,
        names_to = "time",
        values_to = "gdp"
    ) %>%
    mutate(time = as.integer(str_sub(time, 2, 5))) %>%
    drop_na()

# downloaded from OECD stats
gdppcchl <- read_xlsx("data/2eb03a68-f308-4af2-9fcd-514fbc08329e.xlsx", skip = 6, na = "..") %>%
    clean_names() %>%
    select(year, x2005:x2020) %>%
    rename(reg_id = year) %>%
    mutate(reg_id = str_squish(reg_id)) %>%
    filter(grepl("^CL", reg_id)) %>%
    # mutate(reg_id = str_sub(reg_id, 1, 4)) %>%
    separate(reg_id, c("reg_id","reg_name"), sep = ":", remove = FALSE) %>%
    mutate(reg_name = str_squish(reg_name)) %>%
    filter(reg_id != "CLZZ") %>%
    pivot_longer(
        cols = x2005:x2020,
        names_to = "time",
        values_to = "gdp_pc"
    ) %>%
    mutate(time = as.integer(str_sub(time, 2, 5))) %>%
    drop_na()

gdpchl <- gdpchl %>%
    left_join(gdppcchl, by = c("reg_id", "time")) %>%
    mutate(pop = as.integer(round((gdp * 1000000) / gdp_pc, 0))) %>%
    mutate(iso3 = "CHL")

gdpchl %>%
    filter(reg_id == "CL13")
# OK, I BELIEVE THE NUMBER

gdp <- gdp %>%
    select(-x1) %>%
    bind_rows(gdpchl)

gdp %>%
    filter(reg_id == "CL13")

write_csv(gdp, "data/gdp_pop_tl2_00_20_imputed_l_CHL_PACHA.csv")
