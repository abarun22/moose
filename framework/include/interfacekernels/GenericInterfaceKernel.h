//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "InterfaceKernel.h"
#include "ADInterfaceKernel.h"

template <typename T, bool is_ad>
class GenericInterfaceKernelTempl : public InterfaceKernelTempl<T>
{
public:
  static InputParameters validParams() { return InterfaceKernelTempl<T>::validParams(); };
  GenericInterfaceKernelTempl(const InputParameters & parameters)
    : InterfaceKernelTempl<T>(parameters)
  {
  }
};

template <typename T>
class GenericInterfaceKernelTempl<T, true> : public ADInterfaceKernelTempl<T>
{
public:
  static InputParameters validParams() { return ADInterfaceKernelTempl<T>::validParams(); };
  GenericInterfaceKernelTempl(const InputParameters & parameters)
    : ADInterfaceKernelTempl<T>(parameters)
  {
  }
};

template <bool is_ad>
using GenericInterfaceKernel = GenericInterfaceKernelTempl<Real, is_ad>;

#define usingGenericInterfaceKernelMembers                                                         \
  usingFunctionInterfaceMembers;                                                                   \
  usingPostprocessorInterfaceMembers;                                                              \
  usingMooseObjectMembers;                                                                         \
  usingTransientInterfaceMembers;                                                                  \
  usingTaggingInterfaceMembers;                                                                    \
  using GenericInterfaceKernel<is_ad>::_qp;                                                        \
  using GenericInterfaceKernel<is_ad>::_i;                                                         \
  using GenericInterfaceKernel<is_ad>::_j;                                                         \
  using GenericInterfaceKernel<is_ad>::_u;                                                         \
  using GenericInterfaceKernel<is_ad>::_phi;                                                       \
  using GenericInterfaceKernel<is_ad>::_test;                                                      \
  using GenericInterfaceKernel<is_ad>::_q_point;                                                   \
  using GenericInterfaceKernel<is_ad>::_var;                                                       \
  using GenericInterfaceKernel<is_ad>::_name;                                                      \
  using GenericInterfaceKernel<is_ad>::_neighbor_value;                                            \
  using GenericInterfaceKernel<is_ad>::_test_neighbor;                                             \
  using GenericInterfaceKernel<is_ad>::_phi_neighbor;                                              \
  using Coupleable::getVar;                                                                        \
  using Coupleable::coupled;                                                                       \
  using Coupleable::coupledComponents
