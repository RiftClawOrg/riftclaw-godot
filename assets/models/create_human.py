import bpy
import math
import os

# Clear existing mesh objects
bpy.ops.object.select_all(action='SELECT')
bpy.ops.object.delete(use_global=False)

# Create human body parts using metaballs for organic shapes
# This creates a more realistic human silhouette

def create_metaball(name, location, radius):
    bpy.ops.object.metaball_add(type='BALL', location=location)
    obj = bpy.context.active_object
    obj.name = name
    obj.data.elements[0].radius = radius
    return obj

# Head
head = create_metaball('Head', (0, 0, 1.65), 0.12)

# Torso (chest) - larger
chest = create_metaball('Chest', (0, 0, 1.35), 0.24)

# Stomach - medium
stomach = create_metaball('Stomach', (0, 0, 1.1), 0.20)

# Hips
hips = create_metaball('Hips', (0, 0, 0.85), 0.21)

# Left Upper Arm
l_upper_arm = create_metaball('L_UpperArm', (-0.32, 0, 1.30), 0.09)

# Left Lower Arm
l_lower_arm = create_metaball('L_LowerArm', (-0.42, 0, 1.0), 0.08)

# Right Upper Arm  
r_upper_arm = create_metaball('R_UpperArm', (0.32, 0, 1.30), 0.09)

# Right Lower Arm
r_lower_arm = create_metaball('R_LowerArm', (0.42, 0, 1.0), 0.08)

# Left Thigh
l_thigh = create_metaball('L_Thigh', (-0.14, 0, 0.55), 0.13)

# Left Shin
l_shin = create_metaball('L_Shin', (-0.14, 0, 0.15), 0.10)

# Right Thigh
r_thigh = create_metaball('R_Thigh', (0.14, 0, 0.55), 0.13)

# Right Shin
r_shin = create_metaball('R_Shin', (0.14, 0, 0.15), 0.10)

# Select all metaballs
bpy.ops.object.select_all(action='SELECT')
selected = bpy.context.selected_objects

# Find the active metaball object
metaball_obj = bpy.context.active_object

if metaball_obj and metaball_obj.type == 'META':
    print(f"Found metaball object: {metaball_obj.name}")
    
    # Set resolution for better quality
    metaball_obj.data.resolution = 0.04
    metaball_obj.data.render_resolution = 0.02
    
    # Convert to mesh
    bpy.ops.object.convert(target='MESH')
    
    # Rename
    human_mesh = bpy.context.active_object
    human_mesh.name = "Human_Body"
    
    # Add smooth shading
    bpy.ops.object.shade_smooth()
    
    # Add subdivision surface for smoother look
    subsurf = human_mesh.modifiers.new(name="Subdivision", type='SUBSURF')
    subsurf.levels = 2
    subsurf.render_levels = 3
    subsurf.subdivision_type = 'CATMULL_CLARK'
    
    # Apply the modifier
    bpy.context.view_layer.objects.active = human_mesh
    bpy.ops.object.modifier_apply(modifier="Subdivision")
    
    # Decimate to reduce poly count slightly
    decimate = human_mesh.modifiers.new(name="Decimate", type='DECIMATE')
    decimate.ratio = 0.7
    decimate.use_collapse_triangulate = True
    bpy.ops.object.modifier_apply(modifier="Decimate")
    
    # Create sci-fi suit material
    mat = bpy.data.materials.new(name="Human_Suit")
    mat.use_nodes = True
    
    # Clear default nodes
    nodes = mat.node_tree.nodes
    links = mat.node_tree.links
    nodes.clear()
    
    # Add nodes
    output = nodes.new('ShaderNodeOutputMaterial')
    principled = nodes.new('ShaderNodeBsdfPrincipled')
    
    # Configure principled BSDF
    principled.inputs['Base Color'].default_value = (0.08, 0.10, 0.15, 1.0)
    principled.inputs['Roughness'].default_value = 0.35
    principled.inputs['Metallic'].default_value = 0.15
    principled.inputs['IOR'].default_value = 1.45
    principled.inputs['Specular IOR Level'].default_value = 0.5
    principled.inputs['Coat Weight'].default_value = 0.1
    principled.inputs['Coat Roughness'].default_value = 0.1
    
    # Link nodes
    links.new(principled.outputs['BSDF'], output.inputs['Surface'])
    
    # Assign material
    human_mesh.data.materials.append(mat)
    
    # Add slight bevel for edge highlights
    bevel = human_mesh.modifiers.new(name="Bevel", type='BEVEL')
    bevel.width = 0.005
    bevel.segments = 2
    bevel.limit_method = 'ANGLE'
    bpy.ops.object.modifier_apply(modifier="Bevel")
    
    print(f"Created human mesh with {len(human_mesh.data.vertices)} vertices")

# Export to GLTF
output_path = "/home/clawdintel/.openclaw/workspace/riftclaw-godot/assets/models/human_character.glb"
os.makedirs(os.path.dirname(output_path), exist_ok=True)

# Select only the mesh for export
bpy.ops.object.select_all(action='DESELECT')
if 'Human_Body' in bpy.data.objects:
    bpy.data.objects['Human_Body'].select_set(True)
    bpy.context.view_layer.objects.active = bpy.data.objects['Human_Body']

bpy.ops.export_scene.gltf(
    filepath=output_path,
    export_format='GLB',
    export_materials='EXPORT',
    export_yup=True,
    export_apply=True,
    use_selection=True
)

print(f"✓ Human character exported to: {output_path}")
print(f"✓ File size: {os.path.getsize(output_path) / 1024:.1f} KB")
