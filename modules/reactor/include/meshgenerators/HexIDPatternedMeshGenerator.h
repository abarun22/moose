//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "PatternedHexMeshGenerator.h"
#include "MooseEnum.h"
#include "MeshMetaDataInterface.h"

/**
 * Generates patterned hexagonal meshes with a reporting ID
 */
class HexIDPatternedMeshGenerator : public PatternedHexMeshGenerator
{
public:
  static InputParameters validParams();

  HexIDPatternedMeshGenerator(const InputParameters & parameters);

  std::unique_ptr<MeshBase> generate() override;

protected:
  /// name of integer ID
  const std::string _element_id_name;
  /// integer ID assignment type
  const std::string _assign_type;
  /// flag to indicate if exclude_id is defined
  const bool _use_exclude_id;
  /// flag to indicate if exclude_id is used for each input
  std::vector<bool> _exclude_ids;
  /// hold integer ID for each input pattern cell
  std::vector<std::vector<dof_id_type>> _id_pattern;
};
