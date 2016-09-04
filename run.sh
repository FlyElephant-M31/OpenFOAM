#!/bin/bash
#
#----------------------------------------------#
# Contributor: Tobias Holzmann                 #
# Last Change: February 2015                   #
# Topic:       Multiregion meshing             #
# Email:       Tobias.Holzmann@Holzmann-cfd.de #
#----------------------------------------------#


#-------------------------------------------------------------------------------
cd ${0%/*} || exit 1
clear
foamCleanTutorials
rm -rf 0


#-------------------------------------------------------------------------------
echo -e "
-------------------------------------------------------------------------------
Tutorial by Tobias Holzmann
Generated March 2015
OpenFOAM-2.3.1
OpenFOAM-2.3.x

UPDATED 04.08.2015
-------------------------------------------------------------------------------


Topic: Adaptiv mesh refinement

Requirements: 

  + You need to solve the passive scalar equation for S
  + Do this with fvOptions or compile a new solver (use pimpleDyMFoam)
  * GroovyBC

-------------------------------------------------------------------------------"


#------------------------------------------------------------------------------
echo -e "\n
Start meshing
-------------------------------------------------------------------------------
"


#------------------------------------------------------------------------------
echo -e "   - Create background mesh"
ideasUnvToFoam cad/backgroundMesh.unv > logFile


#------------------------------------------------------------------------------
echo -e "   - Create feature edges"
surfaceFeatureExtract >> logFile


#------------------------------------------------------------------------------
#echo -e "   - Change patch type of front and back to empty (important)"
#changeDictionary >> logFile


#------------------------------------------------------------------------------
echo -e "   - Create the mesh with snappyHexMesh" 
snappyHexMesh -overwrite >> logFile


#------------------------------------------------------------------------------
#echo -e "   - Change patch type of front and back to patch (important)" 
#sed 's/empty/patch/g' constant/polyMesh/boundary -i


#------------------------------------------------------------------------------
echo -e "   - Prepare simulation case" 
rm -r 0 const*/polyMesh/refine*
cp -r 0.org 0


#------------------------------------------------------------------------------
echo -e "\n
-------------------------------------------------------------------------------
End Meshing\n\n
"


#------------------------------------------------------------------------------
echo -e "\n
Start simulation 
-------------------------------------------------------------------------------
"
scalarPimpleDyMFoam > logSimulation


#------------------------------------------------------------------------------
