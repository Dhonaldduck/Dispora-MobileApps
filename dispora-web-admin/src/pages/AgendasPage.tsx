import React, { useEffect, useState } from 'react';
import api from '../api';
import { Plus, Edit2, Trash2, Search, X, Loader2, MapPin, CalendarDays } from 'lucide-react';

interface Agenda {
  id: number;
  title: string;
  category?: string;
  description: string;
  location: string;
  startDate: string;
  endDate: string;
  organizer?: string;
  thumbnailUrl?: string;
}

export const AgendasPage: React.FC = () => {
  const [agendas, setAgendas] = useState<Agenda[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingAgendaId, setEditingAgendaId] = useState<number | string | null>(null);
  
  // Form State
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [location, setLocation] = useState('');
  const [startDate, setStartDate] = useState('');
  const [endDate, setEndDate] = useState('');
  const [category, setCategory] = useState('');
  const [organizer, setOrganizer] = useState('');
  const [posterFile, setPosterFile] = useState<File | null>(null);
  const [previewUrl, setPreviewUrl] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);

  
  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files[0]) {
      const file = e.target.files[0];
      setPosterFile(file);
      setPreviewUrl(URL.createObjectURL(file));
    }
  };

  const fetchAgendas = async () => {
    setIsLoading(true);
    try {
      const response = await api.get('/agendas');
      setAgendas(response.data.data || response.data || []);
    } catch (error) {
      console.error('Failed to fetch agendas', error);
      // Fallback
      setAgendas([
        { id: 1, title: 'Sosialisasi Pemuda Tangguh', description: 'Acara sosialisasi kepemudaan', location: 'Gedung Pemuda', startDate: '2024-09-01T08:00', endDate: '2024-09-01T15:00' },
      ]);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchAgendas();
  }, []);

  
  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsSubmitting(true);
    try {
      let uploadedUrl = '';
      if (posterFile) {
        const formData = new FormData();
        formData.append('file', posterFile);
        const uploadRes = await api.post('/agendas/upload', formData, {
          headers: { 'Content-Type': 'multipart/form-data' }
        });
        // Handle different possible response structures
        uploadedUrl = uploadRes.data?.filePath || uploadRes.data?.data?.url || uploadRes.data?.url || uploadRes.data || '';
      }

      const payload = { 
        title, 
        category,
        description,
        location,
        startDate: new Date(startDate).toISOString(),
        endDate: new Date(endDate).toISOString(),
        organizer,
        isPublished: true,
        ...(uploadedUrl && { thumbnailUrl: uploadedUrl })
      };

      if (editingAgendaId) {
        await api.patch(`/agendas/${editingAgendaId}`, payload);
      } else {
        await api.post('/agendas', payload);
      }
      
      setIsModalOpen(false);
      resetForm();
      fetchAgendas();
    } catch (error) {
      console.error('Failed to create agenda', error);
      alert('Gagal menambahkan agenda');
    } finally {
      setIsSubmitting(false);
    }
  };


  
  const resetForm = () => {
    setTitle('');
    setCategory('');
    setDescription('');
    setLocation('');
    setStartDate('');
    setEndDate('');
    setOrganizer('');
    setPosterFile(null);
    setPreviewUrl('');
    setEditingAgendaId(null);
  };

  const openModal = () => {
    resetForm();
    setIsModalOpen(true);
  };

  const handleEdit = (agenda: Agenda) => {
    setEditingAgendaId(agenda.id);
    setTitle(agenda.title);
    setCategory(agenda.category || '');
    setDescription(agenda.description);
    setLocation(agenda.location);
    // Convert UTC to local time for datetime-local input
    const localStart = new Date(new Date(agenda.startDate).getTime() - new Date().getTimezoneOffset() * 60000).toISOString().slice(0, 16);
    const localEnd = new Date(new Date(agenda.endDate).getTime() - new Date().getTimezoneOffset() * 60000).toISOString().slice(0, 16);
    setStartDate(localStart);
    setEndDate(localEnd);
    setOrganizer(agenda.organizer || '');
    setPreviewUrl(agenda.thumbnailUrl ? (agenda.thumbnailUrl.startsWith('http') ? agenda.thumbnailUrl : `http://127.0.0.1:3000${agenda.thumbnailUrl}`) : '');
    setPosterFile(null);
    setIsModalOpen(true);
  };

  const handleDelete = async (id: number | string) => {
    if (window.confirm('Yakin ingin menghapus agenda ini?')) {
      try {
        await api.delete(`/agendas/${id}`);
        fetchAgendas();
      } catch (error) {
        console.error('Failed to delete agenda', error);
        alert('Gagal menghapus agenda');
      }
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h1 className="text-2xl font-bold text-slate-900">Manajemen Agenda</h1>
          <p className="text-sm text-slate-500 mt-1">Kelola jadwal kegiatan dan acara kepemudaan.</p>
        </div>
        <button
          onClick={openModal}
          className="flex items-center gap-2 bg-primary-600 hover:bg-primary-700 text-white px-4 py-2 rounded-lg font-medium transition-colors shadow-sm"
        >
          <Plus size={18} />
          Tambah Agenda
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
              placeholder="Cari agenda..."
              className="block w-full pl-10 pr-3 py-2 border border-slate-300 rounded-lg text-sm focus:ring-primary-500 focus:border-primary-500 outline-none"
            />
          </div>
        </div>
        
        <div className="overflow-x-auto">
          <table className="w-full text-left text-sm text-slate-600">
            <thead className="bg-slate-50 text-slate-700 border-b border-slate-200">
              <tr>
                <th className="px-6 py-4 font-semibold w-20">Poster</th>
                <th className="px-6 py-4 font-semibold">Acara</th>
                <th className="px-6 py-4 font-semibold">Waktu & Tempat</th>
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
              ) : agendas.length === 0 ? (
                <tr>
                  <td colSpan={4} className="px-6 py-8 text-center text-slate-500">
                    Belum ada data agenda.
                  </td>
                </tr>
              ) : (
                agendas.map((item) => (
                  <tr key={item.id} className="hover:bg-slate-50 transition-colors">
                    <td className="px-6 py-4">
    {item.thumbnailUrl ? (
      <img src={item.thumbnailUrl} alt={item.title} className="w-12 h-12 object-cover rounded-lg border border-slate-200" />
    ) : (
      <div className="w-12 h-12 bg-slate-100 rounded-lg border border-slate-200 flex items-center justify-center text-slate-400 text-xs">No Img</div>
    )}
  </td>
                    <td className="px-6 py-4">
                      <div className="font-medium text-slate-900">{item.title}</div>
                      <div className="text-xs text-slate-500 mt-1 line-clamp-1">{item.description}</div>
                    </td>
                    <td className="px-6 py-4">
                      <div className="flex items-center gap-1.5 text-slate-600 mb-1">
                        <CalendarDays size={14} className="text-primary-500" />
                        <span>{new Date(item.startDate).toLocaleDateString('id-ID', { hour: '2-digit', minute: '2-digit' })}</span>
                      </div>
                      <div className="flex items-center gap-1.5 text-slate-600">
                        <MapPin size={14} className="text-primary-500" />
                        <span>{item.location}</span>
                      </div>
                    </td>
                    <td className="px-6 py-4 text-right">
                      <div className="flex justify-end gap-2">
                        <button 
                          onClick={() => handleEdit(item)}
                          className="p-1.5 text-slate-400 hover:text-primary-600 hover:bg-primary-50 rounded transition-colors"
                        >
                          <Edit2 size={18} />
                        </button>
                        <button 
                          onClick={() => handleDelete(item.id)}
                          className="p-1.5 text-slate-400 hover:text-red-600 hover:bg-red-50 rounded transition-colors"
                        >
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
              <h2 className="text-xl font-bold text-slate-900">{editingAgendaId ? 'Edit Agenda' : 'Tambah Agenda Baru'}</h2>
              <button 
                onClick={() => setIsModalOpen(false)}
                className="text-slate-400 hover:text-slate-600 transition-colors"
              >
                <X size={24} />
              </button>
            </div>
            
            <form onSubmit={handleSubmit} className="p-5 flex-1 overflow-y-auto space-y-4">
              
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">
                  Poster Event
                </label>
                <div className="mt-1 flex justify-center px-6 pt-5 pb-6 border-2 border-slate-300 border-dashed rounded-lg">
                  <div className="space-y-1 text-center">
                    {previewUrl ? (
                      <div className="mb-4">
                        <img src={previewUrl} alt="Preview" className="mx-auto h-32 object-contain" />
                      </div>
                    ) : (
                      <svg className="mx-auto h-12 w-12 text-slate-400" stroke="currentColor" fill="none" viewBox="0 0 48 48" aria-hidden="true">
                        <path d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" />
                      </svg>
                    )}
                    <div className="flex text-sm text-slate-600 justify-center">
                      <label htmlFor="file-upload" className="relative cursor-pointer bg-white rounded-md font-medium text-primary-600 hover:text-primary-500 focus-within:outline-none">
                        <span>Unggah file</span>
                        <input id="file-upload" name="file-upload" type="file" className="sr-only" accept="image/*" onChange={handleFileChange} />
                      </label>
                      <p className="pl-1">atau tarik dan lepas</p>
                    </div>
                    <p className="text-xs text-slate-500">PNG, JPG, GIF hingga 5MB</p>
                  </div>
                </div>
              </div>

              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1" htmlFor="title">
                  Nama Agenda / Event
                </label>
                <input
                  id="title"
                  type="text"
                  value={title}
                  onChange={(e) => setTitle(e.target.value)}
                  className="block w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors outline-none"
                  placeholder="Masukkan nama kegiatan"
                  required
                />
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1" htmlFor="category">
                    Kategori / Cabang Olahraga
                  </label>
                  <input
                    id="category"
                    type="text"
                    value={category}
                    onChange={(e) => setCategory(e.target.value)}
                    className="block w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors outline-none"
                    placeholder="Misal: Sepak Bola, Lari"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1" htmlFor="organizer">
                    Penyelenggara / Kontak
                  </label>
                  <input
                    id="organizer"
                    type="text"
                    value={organizer}
                    onChange={(e) => setOrganizer(e.target.value)}
                    className="block w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors outline-none"
                    placeholder="Nama penyelenggara"
                  />
                </div>
              </div>
              
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1" htmlFor="location">
                  Lokasi / Fasilitas
                </label>
                <input
                  id="location"
                  type="text"
                  value={location}
                  onChange={(e) => setLocation(e.target.value)}
                  className="block w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors outline-none"
                  placeholder="Lokasi kegiatan"
                  required
                />
              </div>


              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1" htmlFor="startDate">
                    Waktu Mulai
                  </label>
                  <input
                    id="startDate"
                    type="datetime-local"
                    value={startDate}
                    onChange={(e) => setStartDate(e.target.value)}
                    className="block w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors outline-none"
                    required
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1" htmlFor="endDate">
                    Waktu Selesai
                  </label>
                  <input
                    id="endDate"
                    type="datetime-local"
                    value={endDate}
                    onChange={(e) => setEndDate(e.target.value)}
                    className="block w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors outline-none"
                    required
                  />
                </div>
              </div>
              
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1" htmlFor="description">
                  Deskripsi Agenda
                </label>
                <textarea
                  id="description"
                  rows={4}
                  value={description}
                  onChange={(e) => setDescription(e.target.value)}
                  className="block w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors outline-none resize-y"
                  placeholder="Ketik deskripsi kegiatan..."
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
                  'Simpan Agenda'
                )}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
