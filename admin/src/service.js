import axios from 'axios';

export default {
  getAllProjects() {
    return axios.get('http://localhost:3000/')
      .then(res => res.data).catch(err => console.log('cant get all projects', err))
  },

  getProject(id) {
    return axios.get('http://localhost:3000/project', { params: { id }})
      .then(res => res.data[0]).catch(err => console.log('cant get all projects', err))
  },

  addNewProject(name) {
    return axios.post('http://localhost:3000/', { name })
      .then(res => res.data._id).catch(err => console.log('could not add new project', err))
  },

  saveScreens(id, screens) {
    return axios.post('http://localhost:3000/screens', { id, screens })
      .then(res => res).catch(err => console.log('could not add new project', err))
  },
};