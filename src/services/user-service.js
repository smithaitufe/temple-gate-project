import { get, post, put } from '../utils';

export class UserService {
  getUsers(params = null) {
    if (params) return get(`/api/v1/users?${params}`);
    return get(`/api/v1/users`);
  }
  getUserById(id) {
    return new Promise((reject) => {
      if (!id) reject("Parameter not specified");
      return get(`/api/v1/users/${id}`);
    });
  }
  saveUser(user) {
    return new Promise(reject => {
      if (!user) reject("Parameter not specified");
      const {id} = user;
      const data = { user: user };
      if (id) return put(`/api/v1/users/${id}`, data);
      return post(`/api/v1/users`, data);
    })
  }
  getUserProfile(params) {
    return new Promise( reject => {
      if (!params) reject("Parameter not specified");
      return get(`/api/v1/user_profiles?${params}`);
    })
  }
  getUserProfileById(id) {
    return new Promise(reject => {
      if (!id) reject("Parameter not specified");
      return get(`/api/v1/user_profiles?${id}`);
    })
  }
  saveUserProfile(user_profile = null) {
    return new Promise(reject => {
      if (!user_profile) reject("User profile not specified");
      const data = { user_profile: user_profile };
      const { id } = user_profile;
      if (id) return put(`/api/v1/user_profiles/${id}`, data)
      return post(`/api/v1/user_profiles`, data)
    })
  }

}
