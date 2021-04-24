//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "FVFluxKernel.h"

class SinglePhaseFluidProperties;

class CNSFVLaxFriedrichs : public FVFluxKernel
{
public:
  static InputParameters validParams();
  CNSFVLaxFriedrichs(const InputParameters & params);

protected:
  virtual ADReal computeQpResidual() override;
  void computeAValues();

  const SinglePhaseFluidProperties & _fluid;
  const ADMaterialProperty<RealVectorValue> & _vel_elem;
  const ADMaterialProperty<RealVectorValue> & _vel_neighbor;
  const ADMaterialProperty<Real> & _rho_elem;
  const ADMaterialProperty<Real> & _rho_neighbor;
  const ADMaterialProperty<Real> & _rhou_elem;
  const ADMaterialProperty<Real> & _rhou_neighbor;
  const ADMaterialProperty<Real> & _rho_ht_elem;
  const ADMaterialProperty<Real> & _rho_ht_neighbor;
  const ADMaterialProperty<Real> & _T_fluid_elem;
  const ADMaterialProperty<Real> & _T_fluid_neighbor;
  const ADMaterialProperty<Real> & _pressure_elem;
  const ADMaterialProperty<Real> & _pressure_neighbor;
  const MooseEnum _eqn;
  const unsigned int _index;

  RealVectorValue _Sf;
  ADReal _vSf_elem;
  ADReal _vSf_neighbor;
  ADReal _cSf_elem;
  ADReal _cSf_neighbor;
  ADReal _psi_elem;
  ADReal _psi_neighbor;
  ADReal _alpha_elem;
  ADReal _alpha_neighbor;
  ADReal _psi_max;
  ADReal _omega;
  ADReal _adjusted_vSf_elem;
  ADReal _adjusted_vSf_neighbor;
  ADReal _adjusted_vSf_max;
};
