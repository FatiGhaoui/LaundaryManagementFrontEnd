import axios from 'axios';


export function axiosConfig() {
    axios.interceptors.request.use(config => {
        config.auth = {
            username: 'user',
            password: 'myPassword'
        };
        return config;
    });
}