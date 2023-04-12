mu = 2.6
rho = 1.0
advected_interp_method = 'average'
velocity_interp_method = 'rc'

momentum_tag = "non_pressure"

[Mesh]
  [mesh]
    type = CartesianMeshGenerator
    dim = 1
    dx = '0.5 0.5'
    ix = '16 16'
    iy = '10'
    subdomain_id = '1 1'
  []
[]

[GlobalParams]
  rhie_chow_user_object = 'rc'
[]

[Problem]
  nl_sys_names = 'momentum_system pressure_system'
  previous_nl_solution_required = true
[]

[UserObjects]
  [rc]
    type = INSFVRhieChowInterpolatorSegregated
    u = u
    pressure = pressure
  []
[]

[Variables]
  [u]
    type = INSFVVelocityVariable
    initial_condition = 0.5
    nl_sys = momentum_system
  []
  [pressure]
    type = INSFVPressureVariable
    nl_sys = pressure_system
    initial_condition = 0.2
  []
[]

[FVKernels]
  [u_advection]
    type = INSFVMomentumAdvection
    variable = u
    advected_interp_method = ${advected_interp_method}
    velocity_interp_method = ${velocity_interp_method}
    rho = ${rho}
    momentum_component = 'x'
    linearize = true
    extra_vector_tags = ${momentum_tag}
  []
  [u_viscosity]
    type = INSFVMomentumDiffusion
    variable = u
    mu = ${mu}
    momentum_component = 'x'
    extra_vector_tags = ${momentum_tag}
  []
  [u_pressure]
    type = INSFVMomentumPressure
    variable = u
    momentum_component = 'x'
    pressure = pressure
  []
  [p_diffusion]
    type = FVAnisotropicDiffusion
    variable = pressure
    coeff = "Ainv"
    coeff_interp_method = 'average'
  []
  [p_source]
    type = FVDivergence
    variable = pressure
    vector_field = "HbyA"
    force_boundary_execution = true
  []
[]

[FVBCs]
  [inlet-u]
    type = INSFVInletVelocityBC
    boundary = 'left'
    variable = u
    function = '1.1'
  []
  [outlet_p]
    type = INSFVOutletPressureBC
    boundary = 'right'
    variable = pressure
    function = 1.4
  []
[]

[Executioner]
  type = SIMPLE
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -pc_hypre_type -pc_factor_shift_type'
  petsc_options_value = 'hypre boomeramg NONZERO'
  nl_max_its = 1
  l_max_its = 1
  line_search = 'none'
  rhie_chow_user_object = 'rc'
  momentum_system = 'momentum_system'
  pressure_system = 'pressure_system'
  momentum_tag = ${momentum_tag}
  momentum_variable_relaxation = 0.75
  pressure_variable_relaxation = 0.7
  num_iterations = 100

[]

[Postprocessors]
  [inlet_p]
    type = SideAverageValue
    variable = 'pressure'
    boundary = 'left'
  []
  [outlet-u]
    type = SideIntegralVariablePostprocessor
    variable = u
    boundary = 'right'
  []
[]

[Outputs]
  exodus = true
  csv = true
  perf_graph = false
  print_nonlinear_residuals = false
  print_linear_residuals = false
[]
