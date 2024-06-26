# Single element test to check the strain energy density calculation

[GlobalParams]
  displacements = 'disp_x disp_y'
  volumetric_locking_correction = true
[]

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 1
  ny = 1
  xmin = 0
  xmax = 1
  ymin = 0
  ymax = 2
[]

[AuxVariables]
  [./SERD]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Functions]
  [./rampConstantUp]
    type = PiecewiseLinear
    x = '0. 1.'
    y = '0. 1.'
    scale_factor = -100
  [../]
  [./ramp_disp_y]
    type = PiecewiseLinear
    x = '0. 1. 2.'
    y = '0. 6.8e-6 1.36e-5'
  [../]
[]

[Physics/SolidMechanics/QuasiStatic]
  [./master]
    strain = SMALL
    add_variables = true
    incremental = true
    generate_output = 'stress_xx stress_yy stress_zz vonmises_stress elastic_strain_xx elastic_strain_yy elastic_strain_zz strain_xx strain_yy strain_zz'
    planar_formulation = PLANE_STRAIN
  [../]
[]

[AuxKernels]
  [./SERD]
    type = MaterialRealAux
    variable = SERD
    property = strain_energy_rate_density
    execute_on = timestep_end
  [../]
[]

[BCs]
  [./no_x]
    type = DirichletBC
    variable = disp_x
    preset = false
    boundary = 'left'
    value = 0.0
  [../]
  [./no_y]
    type = DirichletBC
    variable = disp_y
    preset = false
    boundary = 'bottom'
    value = 0.0
  [../]
  [./top_disp]
    type = FunctionDirichletBC
    variable = disp_y
    preset = false
    boundary = 'top'
    function = ramp_disp_y
  [../]
[]

[Materials]
  [./elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 206800
    poissons_ratio = 0.0
  [../]
  [./radial_return_stress]
    type = ComputeMultipleInelasticStress
    inelastic_models = 'powerlawcrp'
  [../]
  [./powerlawcrp]
    type = PowerLawCreepStressUpdate
    coefficient = 3.125e-21 # 7.04e-17 #
    n_exponent = 4.0
    m_exponent = 0.0
    activation_energy = 0.0
    # max_inelastic_increment = 0.01
  [../]
  [./strain_energy_rate_density]
    type = StrainEnergyRateDensity
    inelastic_models = 'powerlawcrp'
  [../]
[]

[Executioner]
   type = Transient

  petsc_options_iname = '-ksp_gmres_restart -pc_type -pc_hypre_type -pc_hypre_boomeramg_max_iter'
  petsc_options_value = '201                hypre    boomeramg      4'

  line_search = 'none'

   l_max_its = 50
   nl_max_its = 20
   nl_abs_tol = 3e-7
   nl_rel_tol = 1e-12
   l_tol = 1e-2

   start_time = 0.0
   dt = 1

   end_time = 2
   num_steps = 2
[]

[Postprocessors]
  [./etxx]
    type = ElementalVariableValue
    variable = strain_xx
    elementid = 0
  [../]
  [./etyy]
    type = ElementalVariableValue
    variable = strain_yy
    elementid = 0
  [../]
  [./etzz]
    type = ElementalVariableValue
    variable = strain_zz
    elementid = 0
  [../]
  [./sigxx]
    type = ElementAverageValue
    variable = stress_xx
  [../]
  [./sigyy]
    type = ElementAverageValue
    variable = stress_yy
  [../]
  [./sigzz]
    type = ElementAverageValue
    variable = stress_zz
  [../]
  [./SERD]
    type = ElementAverageValue
    variable = SERD
  [../]
[]

[Outputs]
  csv = true
[]
