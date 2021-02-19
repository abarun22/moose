[Mesh]
  [cartesian]
    type = GeneratedMeshGenerator
    dim = 1
    xmin = 0
    # xmax = 30
    # nx = 30
    xmax = 10
    nx = 2000
  []
  # [changing_porosity]
  #   input = cartesian
  #   type = SubdomainBoundingBoxGenerator
  #   bottom_left = '10 0 0'
  #   top_right = '20 1 1'
  #   block_id = 1
  # []
  [constant_again_porosity]
    input = cartesian
    type = SubdomainBoundingBoxGenerator
    bottom_left = '5 0 0'
    top_right = '10 1 1'
    block_id = 1
  []
[]

[Modules]
  [FluidProperties]
    [fp]
      type = IdealGasFluidProperties
      gamma = 2
    []
  []
[]

[Problem]
  kernel_coverage_check = false
[]

[Variables]
  [rho]
    type = MooseVariableFVReal
    initial_condition = 1
  []
  [rho_u]
    type = MooseVariableFVReal
    initial_condition = 1e-15
  []
  [rho_et]
    type = MooseVariableFVReal
    initial_condition = 10.5
  []
[]

[AuxVariables]
  [specific_volume]
    type = MooseVariableFVReal
  []
  [pressure]
    type = MooseVariableFVReal
  []
  [specific_internal_energy]
    type = MooseVariableFVReal
  []
  [vel_x]
    type = MooseVariableFVReal
  []
  [porosity]
    type = MooseVariableFVReal
  []
  [superficial_vel_x]
    type = MooseVariableFVReal
  []
  [mach]
    type = MooseVariableFVReal
  []
[]

[AuxKernels]
  [specific_volume]
    type = SpecificVolumeAux
    variable = specific_volume
    rho = rho
    execute_on = 'timestep_end'
  []
  [vel_x]
    type = NSVelocityAux
    variable = vel_x
    rho = rho
    momentum = rho_u
    execute_on = 'timestep_end'
  []
  [specific_internal_energy]
    type = NSInternalEnergyAux
    variable = specific_internal_energy
    rho = rho
    vel_x = vel_x
    rho_et = rho_et
    execute_on = 'timestep_end'
  []
  [pressure]
    type = NSPressureAux
    variable = pressure
    specific_volume = specific_volume
    e = specific_internal_energy
    fluid_properties = fp
    execute_on = 'timestep_end'
  []
  [porosity]
    type = MaterialRealAux
    variable = porosity
    property = porosity
    execute_on = 'timestep_end'
  []
  [superficial_vel_x]
    type = ParsedAux
    variable = superficial_vel_x
    function = 'vel_x * porosity'
    args = 'vel_x porosity'
    execute_on = 'timestep_end'
  []
  [mach]
    type = NSMachAux
    variable = mach
    vel_x = vel_x
    e = specific_internal_energy
    specific_volume = specific_volume
    execute_on = 'timestep_end'
    fluid_properties = 'fp'
  []
[]

[FVKernels]
  [mass_time]
    type = FVPorosityTimeDerivative
    variable = rho
  []
  [mass_advection]
    type = FVMatAdvectionFluxBased
    variable = rho
    vel = superficial_velocity
  []

  [momentum_time]
    type = FVPorosityTimeDerivative
    variable = rho_u
  []
  [momentum_advection]
    type = FVMatAdvectionFluxBased
    variable = rho_u
    vel = superficial_velocity
  []
  [momentum_pressure]
    type = FVPorosityMomentumPressure
    variable = rho_u
    momentum_component = 'x'
  []

  [energy_time]
    type = FVPorosityTimeDerivative
    variable = rho_et
  []
  [energy_advection]
    type = FVMatAdvectionFluxBased
    variable = rho_et
    advected_quantity = 'rho_ht'
    vel = superficial_velocity
  []
[]

[FVBCs]
  # [rho_left]
  #   type = FVDirichletBC
  #   boundary = 'left'
  #   variable = rho
  #   value = 1
  # []
  [rho_left]
    type = FVNeumannBC
    boundary = 'left'
    variable = rho
    value = 1
  []
  [rho_right]
    type = FVMatAdvectionFluxBasedOutflowBC
    boundary = 'right'
    variable = rho
    vel = superficial_velocity
  []
  # [rho_u_left]
  #   type = FVDirichletBC
  #   boundary = 'left'
  #   variable = rho_u
  #   value = 1
  # []
  [rho_u_left]
    type = FVNeumannBC
    boundary = 'left'
    variable = rho_u
    value = 1
  []
  [rho_u_right]
    type = FVMatAdvectionFluxBasedOutflowBC
    boundary = 'right'
    variable = rho_u
    vel = superficial_velocity
  []
  # [rho_et_left]
  #   type = FVDirichletBC
  #   boundary = 'left'
  #   variable = rho_et
  #   value = 1
  # []
  [rho_et_left]
    type = FVNeumannBC
    boundary = 'left'
    variable = rho_et
    value = 20.5
  []
  [rho_et_right]
    type = FVMatAdvectionFluxBasedOutflowBC
    boundary = 'right'
    variable = rho_et
    vel = superficial_velocity
    advected_quantity = 'rho_ht'
  []
[]

[Materials]
  [var_mat]
    type = ConservedVarMaterial
    rho = rho
    rhou = rho_u
    rho_et = rho_et
    fp = fp
    porosity = porosity
  []
  [porosity_left]
    type = GenericConstantMaterial
    prop_names = 'porosity'
    prop_values = '1'
    block = 0
  []
  # [porosity_changing]
  #   type = GenericFunctionMaterial
  #   prop_names = 'porosity'
  #   prop_values = 'changing_eps'
  #   block = 1
  # []
  [porosity_right]
    type = GenericConstantMaterial
    prop_names = 'porosity'
    prop_values = '0.5'
    block = 1
  []
[]

[Functions]
  [changing_eps]
    type = ParsedFunction
    value = '-1/20 * x + 3/2'
  []
[]

[Executioner]
  # type = Steady
  # nl_rel_tol = 1e-3
  solve_type = NEWTON
  # nl_rel_tol = 1e-12
  type = Transient
  num_steps = 1000
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.1
  []
  steady_state_detection = true
  # abort_on_solve_fail = true
[]

[Outputs]
  exodus = true
  checkpoint = true
[]

[Debug]
  show_var_residual_norms = true
[]