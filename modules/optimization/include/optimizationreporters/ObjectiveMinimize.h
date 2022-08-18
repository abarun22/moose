//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "OptimizationReporter.h"

class ObjectiveMinimize : public OptimizationReporter
{
public:
  static InputParameters validParams();
  ObjectiveMinimize(const InputParameters & parameters);
  virtual Real computeAndCheckObjective(bool solver_converged) override;

protected:
  virtual void updateParameters(const libMesh::PetscVector<Number> & x) override;

private:
  Real _bound_adjustment = 0.0;
};
