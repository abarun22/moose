[Mesh]
  [generated]
    type = GeneratedMeshGenerator
    dim = 2
    xmin = 0
    xmax = 1
    nx = 3
    ymin = -2
    ymax = 3
    ny = 5
  []
[]

[Problem]
  kernel_coverage_check = false
[]

[Variables]
  [u]
  []
  [trigger_fv_on]
    fv = true
    family = MONOMIAL
    order = CONSTANT
  []
[]

[AuxVariables]
  [v]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[VectorPostprocessors]
  [face_info]
    type = TestFaceInfo
    symbol_names = 'u v'
  []
[]

[Executioner]
  type = Steady
[]

[Outputs]
  csv = true
[]
