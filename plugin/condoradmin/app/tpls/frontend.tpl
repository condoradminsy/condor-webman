<script setup lang="ts">
import { ref } from 'vue';
const config = ref<Condor.Table.Config>({
  urls: {urls},
  rowKey(row) {
    return row.id;
  },
  columns: {columns}
});
</script>

<template>
  <div>
    <CondorTable :config="config" />
  </div>
</template>
