import { get, post, put, destroy } from '../utils';
export class RoleService {
  getRoles(params = null){
    if(params){
      return get(`/api/v1/roles?${params}`)
    }
    return get(`/api/v1/roles`)
  }
  getRoleById(id){
    return get(`/api/v1/roles/${id}`)
  }
  saveRole(role){
    const { id } = role;
    if(id){
      return post(`/api/v1/roles/${id}`, {role: role})
    }
    return post(`/api/v1/roles`, {role: role})
  }

  getRolesForUser(userId){
      if(!userId) return;
      return get(`/api/v1/user_roles?user_id=${userId}`)
  }
  removeRoleFromUser(userRoleId){
      return destroy(`/api/v1/user_roles/${userRoleId}`,);
  }
  addRoleToUser(userId, roleId){
      if(!userId || !roleId) return;
      const data = { user_role: { user_id: userId, role_id: roleId}}
      return post(`/api/v1/user_roles`, data);
  }


  


}
