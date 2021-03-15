//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include <string>

namespace HeatConduction
{
static const std::string emissivity = "emissivity";
static const std::string T_ambient = "T_ambient";

namespace DefaultValues
{
static const Real epsilon = 1e-8;
}

namespace Constants
{
static const Real sigma = 5.67e-8;
}
}
