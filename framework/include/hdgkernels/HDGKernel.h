//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "KernelBase.h"
#include "HDGData.h"
#include "libmesh/dense_matrix.h"
#include "libmesh/dense_vector.h"

template <typename>
class MooseObjectWarehouse;
class HDGIntegratedBC;

/**
 * A kernel for hybridized finite element formulations
 */
class HDGKernel : public KernelBase, public HDGData
{
public:
  static InputParameters validParams();

  HDGKernel(const InputParameters & parameters);

  virtual void computeResidual() override final;
  virtual void computeJacobian() override final;
  virtual void computeOffDiagJacobian(unsigned int) override final;
  virtual void computeOffDiagJacobianScalar(unsigned int) override final;

  virtual void computeResidualAndJacobian() override final;

  /**
   * Here we compute the updates to the primal variables (solution and gradient) now that we have
   * the update to our dual (Lagrange multiplier) variable
   */
  void computePostLinearSolve();

  virtual void initialSetup() override;

  /// The name of the \p NumericVector that holds the changes in all the global (dual) degrees of
  /// freedom from one Newton iteration to the next
  static const std::string lm_increment_vector_name;

protected:
  /**
   * Perform finite element assembly on the volumetric quadrature points
   */
  virtual void onElement() = 0;

  /**
   * Perform finite element assembly on internal sides
   */
  virtual void onInternalSide() = 0;

  /**
   * Whether we are currently computing global data
   */
  bool computingGlobalData() const { return _computing_global_data; }

  /// The auxiliary system
  SystemBase & _aux_sys;

  /**
   * The (ghosted) increment of the Lagrange multiplier vector. This will be used post-linear solve
   * (pre linesearch) to update the primal solution which resides in the auxiliary system
   */
  const NumericVector<Number> * _lm_increment;

  /// The current boundary ID
  const BoundaryID & _current_bnd_id;

  /// The face quadrature rule
  const QBase * const & _qrule_face;

  /// The physical locations of the quadrature points on the face
  const MooseArray<Point> & _q_point_face;

  /// transformed Jacobian weights on the face
  const MooseArray<Real> & _JxW_face;

  /// coordinate transformation on the face
  const MooseArray<Real> & _coord_face;

  /// face normals
  const MooseArray<Point> & _normals;

  /// Containers for the global degree of freedom numbers for primal and LM variables
  /// respectively. These data members should be set in the derived class
  std::vector<dof_id_type> _primal_dof_indices;
  std::vector<dof_id_type> _lm_dof_indices;

  /// The current neighbor
  const Elem * _neigh;

private:
  /**
   * Local finite element assembly
   */
  void assemble();

  /*
   * Add-in data from the hybridized integrated bc
   */
  void addBCData(const HDGIntegratedBC & hibc);

  /// The current side index
  const unsigned int & _current_side;

  /// Whether we are assembling the Lagrange multiplier residual and Jacobian
  bool _computing_global_data;

  /// The warehouse holding the hybridized integrated boundary conditions
  MooseObjectWarehouse<HDGIntegratedBC> & _hibc_warehouse;

  /// Lagrange multiplier matrix and RHS after eliminating vector and scalar dofs
  DenseMatrix<Number> _K_libmesh;
  DenseVector<Number> _F_libmesh;

  /// Primal matrix inverse
  EigenMatrix _PrimalMatInv;

  // local degree of freedom increment values
  std::vector<Number> _lm_increment_dof_values;
  std::vector<Number> _primal_increment_dof_values;
  EigenVector _LMIncrement, _PrimalIncrement;
};

inline void
HDGKernel::computeResidual()
{
  // Would be nice to error for this but at the time of writing we still do a usually unnecessary
  // initial residual evaluation
  computeResidualAndJacobian();
}

inline void
HDGKernel::computeJacobian()
{
  mooseError("HDG kernels only implement computeResidualAndJacobian");
}

inline void
HDGKernel::computeOffDiagJacobian(unsigned int)
{
  mooseError("HDG kernels only implement computeResidualAndJacobian");
}

inline void
HDGKernel::computeOffDiagJacobianScalar(unsigned int)
{
  mooseError("HDG kernels only implement computeResidualAndJacobian");
}

inline void
HDGKernel::computeResidualAndJacobian()
{
  _computing_global_data = true;
  assemble();
}

inline void
HDGKernel::computePostLinearSolve()
{
  _computing_global_data = false;
  assemble();
}

inline void
HDGKernel::initialSetup()
{
  KernelBase::initialSetup();
  _lm_increment = &_sys.getVector(lm_increment_vector_name);
}
