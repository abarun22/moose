[Mesh]
  [rmp]
    type = ReactorMeshParams
    dim = 3
    geom = "Square"
    assembly_pitch = 7.10315
    axial_regions = '1.0 1.0 1.0'
    axial_mesh_intervals = '2 2 2'
    procedural_region_ids = false
  []

  [pin1]
    type = PinMeshGenerator
    reactor_params = rmp
    pin_type = 2
    pitch = 1.42063
    num_sectors = 6

    mesh_intervals = '4'
    quad_center_elements = true
    extrude = true
  []
[]

[Problem]
  solve = false
[]

[Outputs]
  exodus = true
[]
