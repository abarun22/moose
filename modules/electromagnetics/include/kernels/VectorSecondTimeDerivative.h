//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "VectorTimeKernel.h"

class VectorSecondTimeDerivative : public VectorTimeKernel
{
public:
  static InputParameters validParams();

  VectorSecondTimeDerivative(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual() override;
  virtual Real computeQpJacobian() override;

  const VectorVariableValue & _u_dot_dot;
  const VariableValue & _du_dot_dot_du;

  const Function & _coeff;
};
