import React, { useEffect, useState } from 'react';
import api from '../api';
import { Plus, Edit2, Trash2, Search, X, Loader2, Link as LinkIcon, Tag } from 'lucide-react';

interface YouthService {
  id: number;
  title: string;
  description: string;
  category: string;
  registrationLink: string;
}

export const YouthServicesPage: React.FC = () => {
  const [services, setServices] = useState<YouthService[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [isModalOpen, setIsModalOpen] = useState(false);
  
  // Form State
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [category, setCategory] = useState('Pelatihan');
  const [registrationLink, setRegistrationLink] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);

  const fetchServices = async () => {
    setIsLoading(true);
    try {
      const response = await api.get('/youth-services');
      setServices(response.data.data || response.data || []);
    } catch (error) {
      console.error('Failed to fetch youth services', error);
      // Fallback
      setServices([
        { id: 1, title: 'Pelatihan Kewirausahaan Muda', description: 'Pelatihan dasar bisnis untuk pemula', category: 'Wirausaha', registrationLink: 'https://form.gov/123' },
      ]);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchServices();
  }, []);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsSubmitting(true);
    try {
      await api.post('/youth-services', { 
        title, 
        description,
        category,
        registrationLink,
        isPublished: true
      });
      
      setIsModalOpen(false);
      resetForm();
      fetchServices();
    } catch (error) {
      console.error('Failed to create service', error);
      alert('Gagal menambahkan layanan');
    } finally {
      setIsSubmitting(false);
    }
  };

  const resetForm = () => {
    setTitle('');
    setDescription('');
    setCategory('Pelatihan');
    setRegistrationLink('');
  };

  const openModal = () => {
    resetForm();
    setIsModalOpen(true);
  };

  const getCategoryColor = (cat: string) => {
    switch (cat) {
      case 'Beasiswa': return 'bg-blue-50 text-blue-700 border-blue-200';
      case 'Pelatihan': return 'bg-emerald-50 text-emerald-700 border-emerald-200';
      case 'Wirausaha': return 'bg-amber-50 text-amber-700 border-amber-200';
      default: return 'bg-slate-50 text-slate-700 border-slate-200';
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h1 className="text-2xl font-bold text-slate-900">Layanan Kepemudaan</h1>
          <p className="text-sm text-slate-500 mt-1">Kelola direktori beasiswa, pelatihan, dan program wirausaha.</p>
        </div>
        <button
          onClick={openModal}
          className="flex items-center gap-2 bg-primary-600 hover:bg-primary-700 text-white px-4 py-2 rounded-lg font-medium transition-colors shadow-sm"
        >
          <Plus size={18} />
          Tambah Layanan
        </button>
      </div>

      <div className="bg-white border border-slate-200 rounded-xl shadow-sm overflow-hidden">
        <div className="p-4 border-b border-slate-200 flex justify-between items-center bg-slate-50">
          <div className="relative w-full max-w-sm">
            <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-slate-400">
              <Search size={18} />
            </div>
            <input
              type="text"
              placeholder="Cari layanan..."
              className="block w-full pl-10 pr-3 py-2 border border-slate-300 rounded-lg text-sm focus:ring-primary-500 focus:border-primary-500 outline-none"
            />
          </div>
        </div>
        
        <div className="overflow-x-auto">
          <table className="w-full text-left text-sm text-slate-600">
            <thead className="bg-slate-50 text-slate-700 border-b border-slate-200">
              <tr>
                <th className="px-6 py-4 font-semibold w-16">ID</th>
                <th className="px-6 py-4 font-semibold">Layanan</th>
                <th className="px-6 py-4 font-semibold">Kategori</th>
                <th className="px-6 py-4 font-semibold text-right">Aksi</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-200">
              {isLoading ? (
                <tr>
                  <td colSpan={4} className="px-6 py-8 text-center text-slate-500">
                    <Loader2 size={24} className="animate-spin mx-auto text-primary-500" />
                    <span className="block mt-2">Memuat data...</span>
                  </td>
                </tr>
              ) : services.length === 0 ? (
                <tr>
                  <td colSpan={4} className="px-6 py-8 text-center text-slate-500">
                    Belum ada data layanan.
                  </td>
                </tr>
              ) : (
                services.map((item) => (
                  <tr key={item.id} className="hover:bg-slate-50 transition-colors">
                    <td className="px-6 py-4">{item.id}</td>
                    <td className="px-6 py-4">
                      <div className="font-medium text-slate-900">{item.title}</div>
                      <a href={item.registrationLink} target="_blank" rel="noopener noreferrer" className="flex items-center gap-1.5 text-xs text-primary-600 hover:text-primary-700 mt-1">
                        <LinkIcon size={12} />
                        Link Pendaftaran
                      </a>
                    </td>
                    <td className="px-6 py-4">
                      <span className={`inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-medium border ${getCategoryColor(item.category)}`}>
                        <Tag size={12} />
                        {item.category}
                      </span>
                    </td>
                    <td className="px-6 py-4 text-right">
                      <div className="flex justify-end gap-2">
                        <button className="p-1.5 text-slate-400 hover:text-primary-600 hover:bg-primary-50 rounded transition-colors">
                          <Edit2 size={18} />
                        </button>
                        <button className="p-1.5 text-slate-400 hover:text-red-600 hover:bg-red-50 rounded transition-colors">
                          <Trash2 size={18} />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>

      {isModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
          <div className="absolute inset-0 bg-slate-900/50 backdrop-blur-sm" onClick={() => setIsModalOpen(false)} />
          <div className="relative bg-white rounded-xl shadow-2xl w-full max-w-2xl max-h-[90vh] flex flex-col animate-in fade-in zoom-in-95 duration-200">
            <div className="flex justify-between items-center p-5 border-b border-slate-200">
              <h2 className="text-xl font-bold text-slate-900">Tambah Layanan Baru</h2>
              <button 
                onClick={() => setIsModalOpen(false)}
                className="text-slate-400 hover:text-slate-600 transition-colors"
              >
                <X size={24} />
              </button>
            </div>
            
            <form onSubmit={handleSubmit} className="p-5 flex-1 overflow-y-auto space-y-4">
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1" htmlFor="title">
                  Nama Layanan
                </label>
                <input
                  id="title"
                  type="text"
                  value={title}
                  onChange={(e) => setTitle(e.target.value)}
                  className="block w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors outline-none"
                  placeholder="Masukkan nama program/layanan"
                  required
                />
              </div>
              
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1" htmlFor="category">
                    Kategori Layanan
                  </label>
                  <select
                    id="category"
                    value={category}
                    onChange={(e) => setCategory(e.target.value)}
                    className="block w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors outline-none bg-white"
                    required
                  >
                    <option value="Beasiswa">Beasiswa</option>
                    <option value="Pelatihan">Pelatihan</option>
                    <option value="Wirausaha">Wirausaha</option>
                  </select>
                </div>
                
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1" htmlFor="registrationLink">
                    Link Pendaftaran
                  </label>
                  <input
                    id="registrationLink"
                    type="url"
                    value={registrationLink}
                    onChange={(e) => setRegistrationLink(e.target.value)}
                    className="block w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors outline-none"
                    placeholder="https://..."
                    required
                  />
                </div>
              </div>
              
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1" htmlFor="description">
                  Deskripsi Lengkap
                </label>
                <textarea
                  id="description"
                  rows={5}
                  value={description}
                  onChange={(e) => setDescription(e.target.value)}
                  className="block w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors outline-none resize-y"
                  placeholder="Ketik detail layanan..."
                  required
                />
              </div>
            </form>
            
            <div className="p-5 border-t border-slate-200 bg-slate-50 rounded-b-xl flex justify-end gap-3">
              <button
                type="button"
                onClick={() => setIsModalOpen(false)}
                className="px-4 py-2 text-sm font-medium text-slate-700 bg-white border border-slate-300 rounded-lg hover:bg-slate-50 transition-colors"
              >
                Batal
              </button>
              <button
                onClick={handleSubmit}
                disabled={isSubmitting}
                className="flex items-center gap-2 px-4 py-2 text-sm font-medium text-white bg-primary-600 rounded-lg hover:bg-primary-700 transition-colors disabled:opacity-70 disabled:cursor-not-allowed"
              >
                {isSubmitting ? (
                  <>
                    <Loader2 size={16} className="animate-spin" />
                    Menyimpan...
                  </>
                ) : (
                  'Simpan Layanan'
                )}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
