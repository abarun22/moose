//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "MeshGenerator.h"

/**
 * Generates a pin-like structure for a square grid with the option to be 2- or 3-D.
 */
class AssemblyMeshGenerator : public MeshGenerator
{
public:
  static InputParameters validParams();

  AssemblyMeshGenerator(const InputParameters & parameters);

  std::unique_ptr<MeshBase> generate() override;

protected:
  ///The names of the pins that compose the Assembly
  std::vector<MeshGeneratorName> _inputs;

  ///The id number for the type of the assembly
  subdomain_id_type _assembly_type;

  ///The 2D pin-by-pin layout of the assembly
  std::vector<std::vector<unsigned int>> _pattern;

  ///The inner apothem of any ducts around the assembly
  std::vector<Real> _duct_sizes;

  ///The number of divisions in the mesh outside of the pins and inside of the ducts
  unsigned int _background_intervals;

  ///The number of divisions in the meshes of the ducts
  std::vector<unsigned int> _duct_intervals;

  ///The ID for the background region that will be assigned to the block ID, name, and an extra element integer
  std::vector<subdomain_id_type> _background_region_id;

  ///The ID for the duct regions that will be assigned to the block ID, name, and an extra element integer
  std::vector<std::vector<subdomain_id_type>> _duct_region_ids;

  ///Whether this mesh should be extruded to 3-D, making it the final structure in the reactor mesh
  bool _extrude;

  ///The ReactorMeshParams object that is storing the reactor global information for this reactor geometry mesh
  MeshGeneratorName _reactor_params;

  ///The type of geometry that is being described (Square or Hex, declared in the ReactorMeshParams object)
  std::string _geom_type;

  ///The number of dimensions the mesh is ultimately going to have (2 or 3, declared in the ReactorMeshParams object)
  int _mesh_dimensions;

  ///Whether procedural IDs are to be used rather than declared by the user (declared in the ReactorMeshParams object)
  bool _procedural_ids;

  ///The heights of the axial regions that are stored on the ReactorMeshParams object
  std::vector<Real> _axial_boundaries;

  ///The number of mesh divisions in each axial region that are stored on the ReactorMeshParams object
  std::vector<unsigned int> _axial_intervals;

  ///The number of regions outside of the pins. This includes the background region and any ducts
  unsigned int _peripheral_regions = 0;

  ///A mapping of region IDs and pin-type IDs that are used to allow for extrusion in an ReactorGeometry MeshGenerator
  std::map<subdomain_id_type, std::vector<std::vector<subdomain_id_type>>> _id_map;

  ///The ID of the assembly outer boundary, equal to the assembly type ID + 2000
  boundary_id_type _assembly_boundary_id;

  ///The name of the assembly outer boundary, equal to the concatenation of "outer_assembly_" and the assembly-type ID
  std::string _assembly_boundary_name;

  ///The ultimate name of the mesh for generation. The value of this string depends on whether the mesh is extruded.
  std::string mesh_name;

  /// The final mesh that is generated by the subgenerators;
  /// This mesh is generated by the subgenerators with only element and boundary IDs changed.
  std::unique_ptr<MeshBase> * _build_mesh;
};
