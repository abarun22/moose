[GlobalParams]
  scaling_factor_temperature = 1e1
[]

[Functions]
  [HeatFunction]
    type = ParsedFunction
    expression = 1313127093.32191
  []
[]

[SolidProperties]
  [fuel-mat]
    type = ThermalFunctionSolidProperties
    k = 16
    cp = 191.67
    rho = 1.4583e4
  []
  [gap-mat]
    type = ThermalFunctionSolidProperties
    k = 64
    cp = 1272
    rho = 865
  []
  [clad-mat]
    type = ThermalFunctionSolidProperties
    k = 26
    cp = 638
    rho = 7.646e3
  []
[]

[AuxVariables]
  [power_density]
    family = MONOMIAL
    order = CONSTANT
    block = 'CH1:solid:fuel'
  []
[]

[AuxKernels]
  [mock_power_aux]
    type = FunctionAux
    variable = power_density
    function = HeatFunction
    block = 'CH1:solid:fuel'
  []
[]

[Components]
  [total_power]
    type = TotalPower
    power = 3.0e4
  []

  [CH1:solid]
    type = HeatStructureCylindrical
    position = '0 -0.024 0'
    orientation = '0 0 1'
    length = 0.8
    n_elems = 16

    initial_T = 628.15

    names = 'fuel gap clad'
    widths = '0.003015 0.000465  0.00052'
    n_part_elems = '20 2 2'
    solid_properties = 'fuel-mat gap-mat clad-mat'
    solid_properties_T_ref = '300 300 300'
  []

  [CH1:hgen]
    type = HeatSourceFromPowerDensity
    hs = CH1:solid
    regions = 'fuel'
    power_density = power_density
  []
[]

[Preconditioning]
  [SMP_PJFNK]
    type = SMP
    full = true
  []
[]


[Executioner]
  type = Transient
  scheme = 'bdf2'

  start_time = 0
  dt = 1e-3
  num_steps = 1
  abort_on_solve_fail = true

  solve_type = 'PJFNK'
  nl_rel_tol = 1e-10
  nl_abs_tol = 1e-7
  nl_max_its = 40

  l_tol = 1e-5
  l_max_its = 50
[]

[Outputs]
  [out]
    type = Exodus
  []
[]
