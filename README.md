# Guo-et-al.-2025-NC
This repository contains the scripts used in Guo et al. (2025), "Framework for mapping land-use effects on carbon and climate across perspectives."

1. Figures folder
Contains scripts used to generate the figures presented in the paper.

2. Datapreprocessing folder
Contains three subfolders:

  Regional-BGC-GHG-Tas-RTCRE: Includes scripts used to calculate regional LULUCF emissions and their contribution to average near-surface air temperature (tas) changes in selected regions.

  multi-model_ensemble: Includes scripts used to compute the multi-model ensemble mean.

  signal_separation: Contains scripts for separating local and nonlocal signals, with two subfolders for BGC and BGP effects, respectively:

    BGP: We apply a checkerboard post-processing approach, as described by Winckler et al. (2017).

    BGC: We adapt the method used for local BGP effects to address the challenge that nonlocal BGC effects—which are influenced by land cover—differ between intact grid cells and those affected by LULUCF. As these           differences hinder direct interpolation, we focus on individual land-use tiles (LUTs) within each grid cell. LUTs represent subgrid land units in Earth system models, each defined by a unique combination            of plant functional types (PFTs) and land-use categories (e.g., cropland, pasture, primary or secondary vegetation, or urban). We use subgrid-level data on carbon pool changes for each LUT. Nonlocal BGC             effects are interpolated from intact to LULUCF grid cells for each LUT, then scaled by their fractional cover.

 Reference: Winckler, J., Reick, C. H. & Pongratz, J. Robust identification of local biogeophysical effects of land-cover change in a global climate model. J. Clim. 30, 1159–1176 (2017).

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.16193304.svg)](https://doi.org/10.5281/zenodo.16193304)
