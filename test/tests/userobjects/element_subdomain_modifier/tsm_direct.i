# testing TimedSubdomainModifier

[Problem]
  solve = false
  kernel_coverage_check = false
  material_coverage_check = false
[]

Box2_inactive_id = '3'
Box2_inactive_name = 'Box2_inactive'
inactive_domain_block_ids = ${Box2_inactive_id}
inactive_domain_block_names = ${Box2_inactive_name}

[Mesh]

  [BaseMesh]
    type = GeneratedMeshGenerator
    elem_type = TET4
    dim = 3
    nx = 5
    ny = 5
    nz = 2
    xmin = -10
    xmax = +10
    ymin = -10
    ymax = +10
    zmin = -2
    zmax = +2
  []

  [Box1]
    type = SubdomainBoundingBoxGenerator
    input = "BaseMesh"
    block_id = 1
    location = "INSIDE"
    bottom_left = "-20 -20 -2"
    top_right = "+20 +20 +2"
  []

  [Box2]
    type = SubdomainBoundingBoxGenerator
    input = "Box1"
    block_id = 2
    location = "INSIDE"
    bottom_left = "-2 -2 +2"
    top_right = "+2 +2 0"
  []

  add_subdomain_ids = ${inactive_domain_block_ids}
  add_subdomain_names = ${inactive_domain_block_names}

[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Variables]
  [disp_x]
    order = SECOND
  []
  [disp_y]
    order = SECOND
  []
  [disp_z]
    order = SECOND
  []
[]

# ===== Boundary Conditions: Fixies at XMin, XMax, YMin, YMax, ZMin =====
[BCs]

  [BoundaryXMin_DispX]
    type = DirichletBC
    boundary = 'left'
    variable = disp_x
    value = 0
  []

  [BoundaryXMax_DispX]
    type = DirichletBC
    boundary = 'right'
    variable = disp_x
    value = 0
  []

  [BoundaryYMin_DispY]
    type = DirichletBC
    boundary = 'bottom'
    variable = disp_y
    value = 0
  []

  [BoundaryYMax_DispY]
    type = DirichletBC
    boundary = 'top'
    variable = disp_y
    value = 0
  []

  [BoundaryZMin_DispX]
    type = DirichletBC
    boundary = 'back'
    variable = disp_x
    value = 0
  []

  [BoundaryZMin_DispY]
    type = DirichletBC
    boundary = 'back'
    variable = disp_y
    value = 0
  []

  [BoundaryZMin_DispZ]
    type = DirichletBC
    boundary = 'back'
    variable = disp_z
    value = 0
  []

[]

# move elements between subdomains back and forth
[UserObjects]
  [GlobalSubdomainModifier]
    type = TimedSubdomainModifier
    times = '0.4             0.6'
    blocks_from = '2               3'
    blocks_to = 'Box2_inactive   2' # Subdomain names are permitted ('Box2_inactive' = 3)
    execute_on = 'INITIAL TIMESTEP_BEGIN'
  []
[]

# ===== Executioner =====
[Executioner]
  type = Transient

  end_time = 1.0
  [TimeSteppers]
    [BlockEventTimeStepper]
      type = TimeSequenceStepper
      time_sequence = '0.0 0.2 0.4 0.5 0.6 1.0'
    []
  []

  solve_type = 'PJFNK'
  petsc_options = '-snes_converged_reason'
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = ' lu       mumps'

  nl_abs_tol = 1E-3
  nl_max_its = 400

  l_tol = 1E-3
  l_max_its = 200
[]

[Outputs]
  perf_graph = true
  exodus = true
[]
