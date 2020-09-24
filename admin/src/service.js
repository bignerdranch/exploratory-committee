import axios from 'axios';

export default {
  getAllProjects() {
    return axios.get('http://localhost:3000/')
      .then(res => res.data).catch(err => console.log('cant get all projects', err))
  },

  getProject(id) {
    return axios.get('http://localhost:3000/', { params: {
      id,
    }})
      .then(res => res.data).catch(err => console.log('cant get all projects', err))
  },

  addNewProject (name) {
    return axios.post('http://localhost:3000/', { name })
      .then(res => res).catch(err => console.log('could not add new project', err))
  },
};