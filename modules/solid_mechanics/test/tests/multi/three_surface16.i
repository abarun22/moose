# Plasticit models:
# SimpleTester0 with a = 0 and b = 1 and strength = 1
# SimpleTester1 with a = 1 and b = 0 and strength = 1
# SimpleTester2 with a = 1 and b = 1 and strength = 3
#
# Lame lambda = 0 (Poisson=0).  Lame mu = 0.5E6
#
# A single element is stretched by 3.0E-6m in y direction and 2.1E-6 in z direction.
# trial stress_yy = 3.0 and stress_zz = 2.1
#
# A complicated return will follow, with various contraints being
# deactivated, kuhn-tucker failing, line-searching, etc, but
# the result should be
# stress_yy=1=stress_zz, and internal0=1.1 internal1=2

[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 1
  ny = 1
  nz = 1
  xmin = -0.5
  xmax = 0.5
  ymin = -0.5
  ymax = 0.5
  zmin = -0.5
  zmax = 0.5
[]


[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
  [./disp_z]
  [../]
[]

[Kernels]
  [SolidMechanics]
    displacements = 'disp_x disp_y disp_z'
  [../]
[]


[BCs]
  [./x]
    type = FunctionDirichletBC
    variable = disp_x
    boundary = 'front back'
    function = '0E-6*x'
  [../]
  [./y]
    type = FunctionDirichletBC
    variable = disp_y
    boundary = 'front back'
    function = '3.0E-6*y'
  [../]
  [./z]
    type = FunctionDirichletBC
    variable = disp_z
    boundary = 'front back'
    function = '2.1E-6*z'
  [../]
[]

[AuxVariables]
  [./stress_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_xy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_xz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_zz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./f0]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./f1]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./f2]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./int0]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./int1]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./int2]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./stress_xx]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xx
    index_i = 0
    index_j = 0
  [../]
  [./stress_xy]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xy
    index_i = 0
    index_j = 1
  [../]
  [./stress_xz]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xz
    index_i = 0
    index_j = 2
  [../]
  [./stress_yy]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_yy
    index_i = 1
    index_j = 1
  [../]
  [./stress_yz]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_yz
    index_i = 1
    index_j = 2
  [../]
  [./stress_zz]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_zz
    index_i = 2
    index_j = 2
  [../]
  [./f0]
    type = MaterialStdVectorAux
    property = plastic_yield_function
    index = 0
    variable = f0
  [../]
  [./f1]
    type = MaterialStdVectorAux
    property = plastic_yield_function
    index = 1
    variable = f1
  [../]
  [./f2]
    type = MaterialStdVectorAux
    property = plastic_yield_function
    index = 2
    variable = f2
  [../]
  [./int0]
    type = MaterialStdVectorAux
    property = plastic_internal_parameter
    factor = 1E6
    index = 0
    variable = int0
  [../]
  [./int1]
    type = MaterialStdVectorAux
    property = plastic_internal_parameter
    factor = 1E6
    index = 1
    variable = int1
  [../]
  [./int2]
    type = MaterialStdVectorAux
    property = plastic_internal_parameter
    factor = 1E6
    index = 2
    variable = int2
  [../]
[]

[Postprocessors]
  [./s_xx]
    type = PointValue
    point = '0 0 0'
    variable = stress_xx
  [../]
  [./s_xy]
    type = PointValue
    point = '0 0 0'
    variable = stress_xy
  [../]
  [./s_xz]
    type = PointValue
    point = '0 0 0'
    variable = stress_xz
  [../]
  [./s_yy]
    type = PointValue
    point = '0 0 0'
    variable = stress_yy
  [../]
  [./s_yz]
    type = PointValue
    point = '0 0 0'
    variable = stress_yz
  [../]
  [./s_zz]
    type = PointValue
    point = '0 0 0'
    variable = stress_zz
  [../]
  [./f0]
    type = PointValue
    point = '0 0 0'
    variable = f0
  [../]
  [./f1]
    type = PointValue
    point = '0 0 0'
    variable = f1
  [../]
  [./f2]
    type = PointValue
    point = '0 0 0'
    variable = f2
  [../]
  [./int0]
    type = PointValue
    point = '0 0 0'
    variable = int0
  [../]
  [./int1]
    type = PointValue
    point = '0 0 0'
    variable = int1
  [../]
  [./int2]
    type = PointValue
    point = '0 0 0'
    variable = int2
  [../]
[]

[UserObjects]
  [./simple0]
    type = TensorMechanicsPlasticSimpleTester
    a = 0
    b = 1
    strength = 1
    yield_function_tolerance = 1.0E-6
    internal_constraint_tolerance = 1.0E-6
  [../]
  [./simple1]
    type = TensorMechanicsPlasticSimpleTester
    a = 1
    b = 0
    strength = 1
    yield_function_tolerance = 1.0E-6
    internal_constraint_tolerance = 1.0E-6
  [../]
  [./simple2]
    type = TensorMechanicsPlasticSimpleTester
    a = 1
    b = 1
    strength = 3
    yield_function_tolerance = 1.0E-6
    internal_constraint_tolerance = 1.0E-6
  [../]
[]

[Materials]
  [./elasticity_tensor]
    type = ComputeElasticityTensor
    block = 0
    fill_method = symmetric_isotropic
    C_ijkl = '0 0.5E6'
  [../]
  [./strain]
    type = ComputeFiniteStrain
    block = 0
    displacements = 'disp_x disp_y disp_z'
  [../]
  [./multi]
    type = ComputeMultiPlasticityStress
    block = 0
    ep_plastic_tolerance = 1E-9
    plastic_models = 'simple0 simple1 simple2'
    max_NR_iterations = 4
    min_stepsize = 1
    debug_fspb = crash
    debug_jac_at_stress = '10 0 0 0 10 0 0 0 10'
    debug_jac_at_pm = '1 1 1'
    debug_jac_at_intnl = '1 1 1'
    debug_stress_change = 1E-5
    debug_pm_change = '1E-6 1E-6 1E-6'
    debug_intnl_change = '1E-6 1E-6 1E-6'
  [../]
[]


[Executioner]
  end_time = 1
  dt = 1
  type = Transient
[]


[Outputs]
  file_base = three_surface16
  exodus = false
  [./csv]
    type = CSV
    [../]
[]
