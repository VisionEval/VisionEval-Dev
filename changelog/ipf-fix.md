---
branch: ipf-fix-test
author: Jeremy Raw (jeremy.raw@dot.gov)
date:   2022-02-02
---

## Overview

This pull request does a lot of work to make a change that ultimately just inserts one character
into one line of code! The change fixes a bug in establising a table margins for the iterative
proportional fitting framework function. But the tiny change has the potential to change the results
delivered from working models, so it is important to establish a thorough test procedure to call out
the differences (as well as a control flag that allows users to select the old behavior if they
really need it).

To support thorough testing and comparison, this pull request also implements an update to the model
installation subsystem to allow test models to be created and run but not exposed to end users. You
can (and should) use the mechanism described and implemented here (including the development of the
test.R script with functions `test_ipf()` and `compare_ipf()`) as prototypes for building thorough
tests for your own module changes that have potential end-user consequences.

## Contents of the actual IPF fix

This pull request delivers a tiny fix to the `ipf` function, but because it can lead to quite
different results, it is important to see how big a difference it will make. The test environment
for VELandUse delivered in this pull request makes it easy to do that.

In addition to fixing the bug (just changing an expression `x=0` to `x==0` in one place!), the `ipf`
function was modified to use a VisionEval RunParameter called "fixIPF" which defaults to a non-zero
value (controlling whether or not to apply the fix). If that parameters is explicitly set to 0 in a
model stage's visioneval.cnf, then the fix will NOT be applied and the `ipf` function will do the
same wrong-ish stuff it always did. That means in practice that if it is important to use the old
behavior for consistency of results, you can do that just by adding a line "fixIPF: 0" to the
model's visioneval.cnf file. See the "VERSPM-test-ipf" private model described below for what that
looks like in practice.

In the present case, the VELandUse package has been updated to provide a private "test-ipf" variant
of the VERSPM pop model, with a new visioneval.cnf that just runs the population synthesis step, the
proceeds to run the `VELandUse` modules that make use of the `ipf` function. The stock VERSPM inputs
are replaced with versions that zero out some Bzone employment and some housing units so the `ipf`
fix will possibly yield different fitted outputs.

The test model includes two stages that run the same script on the same inputs, but that differ in
whether or not the `ipf` fix is applied. The inputs are the same for both stages, but differ from
the standard VERSPM in order to have margins for each invocation of `ipf` that include zero values.

The `ipf` function is called from these modules:
  VELandUse::PredictHousing.R (function defined and invoked there)
  VELandUse::AssignParkingRestrictions.R
  VELandUse::LocateEmployment.R

For PredictHousing, one zone in the test input sets SFDU and MFDU to zero in `bzone_dwelling_units.csv`.

For AssignParkingRestriction and LocateEmployment, two zones in the test input are set to have zero
total employment in `bzone_employment.csv`.

Two test functions are provided to run and evaluate the test model. Neither is exported into the end
user `tools/tests` runtime, but they are available using the developer `ve.test("VELandUse")` setup
(see the Testing section below).

The `test_ipf()` function loads and runs the `VERSPM-test-ipf`private model in two stages: applying
the fix and performing the prior calculation. It then compares the outputs of each module using the
`compare_ipf()` function.

The `compare_ipf()` function shows how to do before-and-after comparisons of specific columns in the
Datastore. The Datastore fields needed for the `ipf` test are hard-coded, but it's easy to replace
them with different fields. If there is interest, we might make a more general purpose comparison
function (arbitrary field comparison between models and stages) and move it up into the VisionEval
framework.

## Extended Test Architecture

To support really thorough testing and comparison, this pull request implements an update to the
model installation subsystem to allow "hidden" test models to be created and run. It's important to
hide them since in some cases they will deliberately implement "broken" behavior and we don't want
end users to accidentally use those as the basis for their own work.

You can (and should) use the elaborate mechanism set up here (including the development of the
test.R script with functions `test_ipf()` and `compare_ipf()`) as prototypes for building thorough
tests for module changes that have potential end-user consequences.

The architecture for installModel has been enhanced to classify models in the `inst/models`
directory of a package to be marked as `private: true` (the default is `false`). Models can also be
sought in a specific package (in addition to the end user default of matching model name and variant
name across all public models in all packages). If `private` models are requested, only models and
variants that are private will be searched, and if a package is also named then the variants will
only be sought in that package.

## Testing

Interaction with the provided tests looks like this:

```
# Here's the basic internal test

getwd()      # root of the Github
source("build/VisionEval-dev.R")
ve.build()   # could just ve.build("modules") - don't need the end-user runtime
ve.test("VELandUse")
test_ipf()   # loads and runs the private test model and reports differences by calling compare_ipf()

# You can also call compare_ipf manually (e.g. to evaluate fixing or not fixing the bug).
# Arguments are lists called "unfixed" or "fixed" with:
#   Model=a VEModel object or name openable with openModel; and
#   Stage=a name of a stage within that model
# The outputs of the three modules that use ipf are compared between the two models.

compare_ipf() # default: spelled out in next sample command
compare_ipf(
  unfixed=list(Model="VERSPM-test-ipf",Stage="ipf-broken"),
  fixed=list(Model="VERSPM-test-ipf",Stage="ipf-fixed")
)
```

As a bonus, equivalents of all the original but never-used tests in the VELandUse package have been
resurrected to work with the different models (VERSPM, VERPAT, VE-State) so those are also available.

## Files

You can generate a file summary using the following line of code.

```
git diff --compact-summary development-next
```

The following files were modified in this change:
```
```
