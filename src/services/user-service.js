import { get, post, put } from '../utils';

export class UserService {
    getUsers(params = null){
        if(params){
            return get(`/api/v1/users?${params}`);
        }            
        return get(`/api/v1/users`);
    }
    getUserById(id){
        if(!id){
            throw new Error("Parameter not specified");            
        }
        return get(`/api/v1/users/${id}`);
    }
    saveUser(user){       
        if(!user){
            throw new Error("Parameter not specified");
        }
        const {id} = user;
        const data = {user: user};
        if(id){
            return put(`/api/v1/users/${id}`, data);
        }
        return post(`/api/v1/users`, data);
    }
    getUserProfiles(params = null){

    }
    getUserProfile(params){
        if(!params) throw new Error("Parameter not specified");
        return get(`/api/v1/user_profiles?${params}`);
    }
    getUserProfileById(id){
        if(!id) throw new Error("Parameter not specified");
        return get(`/api/v1/user_profiles?${id}`);
    }
    saveUserProfile(user_profile = null){
        if(!user_profile) throw new Error("Parameter not specified");
        const data = { user_profile: user_profile};
        const { id } = user_profile;
        if(id) return put(`/api/v1/user_profiles/${id}`, data)
        return post(`/api/v1/user_profiles`, data)
    }

}